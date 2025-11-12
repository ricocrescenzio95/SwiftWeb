# React Fiber: Algoritmo di Riconciliazione Completo

## Indice
1. [Introduzione](#introduzione)
2. [Cos'è React Fiber](#cosè-react-fiber)
3. [Struttura del Fiber Node](#struttura-del-fiber-node)
4. [Le Fasi Principali](#le-fasi-principali)
5. [Algoritmo di Riconciliazione](#algoritmo-di-riconciliazione)
6. [Algoritmo di Diff](#algoritmo-di-diff)
7. [Double Buffering](#double-buffering)
8. [Effect List](#effect-list)
9. [Priority e Scheduling](#priority-e-scheduling)
10. [Esempio Pratico](#esempio-pratico)

---

## Introduzione

React Fiber è stata una riscrittura completa dell'algoritmo di riconciliazione di React, introdotta in React 16. L'obiettivo principale è abilitare il **rendering incrementale**: la capacità di dividere il lavoro di rendering in chunk e distribuirlo su più frame.

### Problemi del Vecchio Algoritmo (Stack Reconciler)

Prima di Fiber, React usava un approccio ricorsivo sincrono:
- Una volta iniziato l'aggiornamento, **non poteva essere interrotto**
- Bloccava il thread principale per l'intera durata
- Non permetteva prioritizzazione del lavoro
- Causava frame drop nelle animazioni complesse

### Obiettivi di React Fiber

1. **Pause work**: Interrompere il lavoro e riprenderlo dopo
2. **Assign priority**: Assegnare priorità diverse ai tipi di aggiornamento
3. **Reuse work**: Riutilizzare lavoro completato in precedenza
4. **Abort work**: Abbandonare lavoro non più necessario

---

## Cos'è React Fiber

> "Un fiber è una unità di lavoro"

Un fiber è un oggetto JavaScript che rappresenta:
- Un **virtual stack frame** (frame dello stack virtuale)
- Un **nodo** nell'albero dei componenti React
- Una **descrizione del lavoro** da fare

Invece di fare affidamento sullo stack delle chiamate del browser (call stack), Fiber implementa il proprio **stack virtuale** che può essere controllato manualmente.

---

## Struttura del Fiber Node

Ogni fiber node contiene queste proprietà chiave:

```javascript
function FiberNode(tag, pendingProps, key, mode) {
  // Identità
  this.tag = tag;              // Tipo di componente (Function, Class, Host, etc.)
  this.key = key;              // Chiave univoca tra i siblings
  this.elementType = null;     // Tipo originale dell'elemento
  this.type = null;            // Tipo risolto del componente
  this.stateNode = null;       // Nodo DOM o istanza della classe

  // Struttura ad Albero (Linked List)
  this.return = null;          // Parent fiber (da dove "ritornare")
  this.child = null;           // Primo figlio
  this.sibling = null;         // Prossimo sibling
  this.index = 0;              // Posizione tra i siblings

  // Ref
  this.ref = null;             // Riferimento al nodo DOM
  this.refCleanup = null;      // Cleanup function per ref

  // Props e State
  this.pendingProps = pendingProps;  // Nuove props da processare
  this.memoizedProps = null;         // Props dell'ultimo render
  this.updateQueue = null;           // Coda di aggiornamenti
  this.memoizedState = null;         // State dell'ultimo render
  this.dependencies = null;          // Dipendenze (context, hooks)

  // Effetti
  this.flags = NoFlags;              // Tipo di effetto (Placement, Update, Deletion)
  this.subtreeFlags = NoFlags;       // Flags dei figli
  this.deletions = null;             // Array di figli da eliminare

  // Scheduling
  this.lanes = NoLanes;              // Priorità di questo lavoro
  this.childLanes = NoLanes;         // Priorità richiesta dai figli

  // Double Buffering
  this.alternate = null;             // Fiber gemello (current ↔ work-in-progress)
}
```

### Proprietà Chiave Spiegate

#### 1. **Tag** (Tipo di Fiber)
Identifica il tipo di componente:
- `FunctionComponent` (0)
- `ClassComponent` (1)
- `HostRoot` (3) - Root del container
- `HostComponent` (5) - Elementi DOM (div, span, etc.)
- `HostText` (6) - Nodi di testo

#### 2. **Struttura ad Albero**
Invece di usare un array di children, Fiber usa una **linked list**:
```
Parent
  ↓ child
First Child → sibling → Second Child → sibling → Third Child
  ↓ return      ↓ return       ↓ return
Parent        Parent          Parent
```

Vantaggi:
- Facile inserimento/rimozione di nodi
- Traversal efficiente
- Pause/resume semplificato

#### 3. **Flags (Effect Tags)**
Indicano quale operazione DOM è necessaria:
- `Placement` (2) - Inserire nel DOM
- `Update` (4) - Aggiornare proprietà
- `Deletion` (8) - Rimuovere dal DOM
- `ChildDeletion` (16) - Figli da eliminare

#### 4. **Alternate (Double Buffering)**
Ogni fiber ha un gemello:
- **current tree**: Albero attualmente renderizzato
- **work-in-progress tree**: Albero in costruzione

---

## Le Fasi Principali

React Fiber divide il lavoro in due fasi distinte:

### 1. **Render Phase** (Fase di Riconciliazione)

**Caratteristiche:**
- Può essere **interrotta e ripresa**
- Può essere **eseguita in modo asincrono**
- Non produce **side effects visibili**
- È **pura** (può essere chiamata più volte)

**Cosa succede:**
1. Costruisce il nuovo albero di fiber (work-in-progress tree)
2. Calcola quali cambiamenti sono necessari
3. Marca i fiber con effect flags
4. Costruisce la **effect list** (lista di effetti da applicare)

**Operazioni:**
- `beginWork()`: Processa un fiber e crea i suoi figli
- `completeWork()`: Finalizza un fiber dopo aver processato i figli
- Diff algorithm per determinare cambiamenti

### 2. **Commit Phase** (Fase di Commit)

**Caratteristiche:**
- È **sincrona** (non può essere interrotta)
- È **veloce** (già sappiamo cosa fare)
- Produce **side effects** (mutazioni DOM, lifecycle)

**Cosa succede:**
1. Applica tutti i cambiamenti al DOM
2. Esegue effect hooks e lifecycle methods
3. Aggiorna i ref

**Sub-fasi del Commit:**

```javascript
function commitRoot(root) {
  // 1. Before Mutation Phase
  // - Esegue getSnapshotBeforeUpdate
  // - Programma useEffect
  commitBeforeMutationEffects(root);

  // 2. Mutation Phase
  // - Applica mutazioni DOM (insert, update, delete)
  // - Chiama componentWillUnmount
  commitMutationEffects(root);

  // 3. Layout Phase
  // - Esegue componentDidMount/Update
  // - Esegue useLayoutEffect
  // - Aggiorna ref
  commitLayoutEffects(root);
}
```

---

## Algoritmo di Riconciliazione

La riconciliazione è il processo di determinare quali parti dell'UI devono cambiare.

### Work Loop

```javascript
function workLoop(deadline) {
  // Continua a lavorare finché:
  // 1. C'è lavoro da fare
  // 2. Non abbiamo esaurito il tempo disponibile
  while (workInProgress !== null && !shouldYield()) {
    performUnitOfWork(workInProgress);
  }

  // Se abbiamo ancora lavoro, schedula il prossimo chunk
  if (workInProgress !== null) {
    requestIdleCallback(workLoop);
  } else {
    // Lavoro completato, commit!
    commitRoot(root);
  }
}

function performUnitOfWork(fiber) {
  // 1. Processa questo fiber
  const next = beginWork(fiber);

  // 2. Se ha un figlio, processiamo quello
  if (next !== null) {
    workInProgress = next;
    return;
  }

  // 3. Nessun figlio, completa questo fiber
  completeUnitOfWork(fiber);
}
```

### beginWork: Creazione dei Figli

```javascript
function beginWork(current, workInProgress) {
  // current: fiber nell'albero corrente (può essere null se nuovo)
  // workInProgress: fiber che stiamo costruendo

  // Ottimizzazione: riusa il lavoro precedente se possibile
  if (current !== null && workInProgress.pendingProps === current.memoizedProps) {
    // Props non cambiate, skippa questo albero!
    return bailoutOnAlreadyFinishedWork(current, workInProgress);
  }

  // Props cambiate o nuovo componente, processa in base al tipo
  switch (workInProgress.tag) {
    case FunctionComponent:
      return updateFunctionComponent(current, workInProgress);
    case ClassComponent:
      return updateClassComponent(current, workInProgress);
    case HostComponent:
      return updateHostComponent(current, workInProgress);
    case HostText:
      return null; // Testo non ha figli
  }
}
```

### completeWork: Finalizzazione

```javascript
function completeUnitOfWork(unitOfWork) {
  let completedWork = unitOfWork;

  do {
    const current = completedWork.alternate;
    const returnFiber = completedWork.return;

    // Finalizza questo fiber
    completeWork(current, completedWork);

    // Raccogli gli effetti nella effect list del parent
    if (returnFiber !== null) {
      // Aggiungi gli effetti di questo fiber alla lista del parent
      if (completedWork.flags !== NoFlags) {
        if (returnFiber.firstEffect === null) {
          returnFiber.firstEffect = completedWork;
        }
        returnFiber.lastEffect.nextEffect = completedWork;
        returnFiber.lastEffect = completedWork;
      }
    }

    // C'è un sibling? Processiamo quello
    const siblingFiber = completedWork.sibling;
    if (siblingFiber !== null) {
      workInProgress = siblingFiber;
      return;
    }

    // Nessun sibling, risali al parent
    completedWork = returnFiber;
    workInProgress = completedWork;
  } while (completedWork !== null);
}
```

---

## Algoritmo di Diff

React usa un algoritmo di diff **euristico O(n)** invece di O(n³), basato su due assunzioni:

### Assunzioni

1. **Elementi di tipo diverso producono alberi diversi**
   - Se cambi da `<div>` a `<span>`, distruggi l'intero sottoalbero

2. **La key prop identifica elementi stabili**
   - Gli elementi con la stessa key possono essere riutilizzati

### Regole di Diffing

#### 1. **Elementi di Tipo Diverso**

```javascript
// Prima
<div><Counter /></div>

// Dopo
<span><Counter /></span>

// Risultato: Distrugge <div> e tutto il sottoalbero, ricrea <span>
```

#### 2. **Elementi dello Stesso Tipo**

```javascript
// Prima
<div className="before" title="stuff" />

// Dopo
<div className="after" title="stuff" />

// Risultato: Mantiene lo stesso nodo DOM, aggiorna solo className
```

#### 3. **Ricorsione sui Figli (Senza Key)**

```javascript
// Prima
<ul>
  <li>Duke</li>
  <li>Villanova</li>
</ul>

// Dopo
<ul>
  <li>Connecticut</li>
  <li>Duke</li>
  <li>Villanova</li>
</ul>

// Risultato (INEFFICIENTE):
// - Muta primo <li> da "Duke" a "Connecticut"
// - Muta secondo <li> da "Villanova" a "Duke"
// - Inserisce nuovo <li> "Villanova"
```

#### 4. **Riconciliazione con Key**

```javascript
// Prima
<ul>
  <li key="2015">Duke</li>
  <li key="2016">Villanova</li>
</ul>

// Dopo
<ul>
  <li key="2014">Connecticut</li>
  <li key="2015">Duke</li>
  <li key="2016">Villanova</li>
</ul>

// Risultato (EFFICIENTE):
// - Mantiene <li key="2015"> e <li key="2016"> invariati
// - Inserisce solo il nuovo <li key="2014">
```

### Implementazione Diff Children

```javascript
function reconcileChildrenArray(returnFiber, currentFirstChild, newChildren) {
  let resultingFirstChild = null;
  let previousNewFiber = null;

  let oldFiber = currentFirstChild;
  let lastPlacedIndex = 0;
  let newIdx = 0;
  let nextOldFiber = null;

  // FASE 1: Confronta in ordine finché possibile
  for (; oldFiber !== null && newIdx < newChildren.length; newIdx++) {
    if (oldFiber.index > newIdx) {
      nextOldFiber = oldFiber;
      oldFiber = null;
    } else {
      nextOldFiber = oldFiber.sibling;
    }

    const newFiber = updateSlot(returnFiber, oldFiber, newChildren[newIdx]);

    if (newFiber === null) {
      // Non possiamo riusare, esci dal loop
      break;
    }

    if (oldFiber && newFiber.alternate === null) {
      // Matching key ma tipo diverso, elimina il vecchio
      deleteChild(returnFiber, oldFiber);
    }

    lastPlacedIndex = placeChild(newFiber, lastPlacedIndex, newIdx);

    if (previousNewFiber === null) {
      resultingFirstChild = newFiber;
    } else {
      previousNewFiber.sibling = newFiber;
    }
    previousNewFiber = newFiber;
    oldFiber = nextOldFiber;
  }

  // FASE 2: Tutti i nuovi figli processati, elimina i vecchi rimanenti
  if (newIdx === newChildren.length) {
    deleteRemainingChildren(returnFiber, oldFiber);
    return resultingFirstChild;
  }

  // FASE 3: Nessun vecchio fiber rimanente, inserisci i nuovi
  if (oldFiber === null) {
    for (; newIdx < newChildren.length; newIdx++) {
      const newFiber = createChild(returnFiber, newChildren[newIdx]);
      lastPlacedIndex = placeChild(newFiber, lastPlacedIndex, newIdx);
      if (previousNewFiber === null) {
        resultingFirstChild = newFiber;
      } else {
        previousNewFiber.sibling = newFiber;
      }
      previousNewFiber = newFiber;
    }
    return resultingFirstChild;
  }

  // FASE 4: Crea una mappa dei vecchi fibers per key
  const existingChildren = mapRemainingChildren(returnFiber, oldFiber);

  // FASE 5: Cerca match nella mappa
  for (; newIdx < newChildren.length; newIdx++) {
    const newFiber = updateFromMap(existingChildren, returnFiber, newIdx, newChildren[newIdx]);

    if (newFiber !== null) {
      if (newFiber.alternate !== null) {
        // Fiber riusato, rimuovi dalla mappa
        existingChildren.delete(newFiber.key === null ? newIdx : newFiber.key);
      }
      lastPlacedIndex = placeChild(newFiber, lastPlacedIndex, newIdx);
      if (previousNewFiber === null) {
        resultingFirstChild = newFiber;
      } else {
        previousNewFiber.sibling = newFiber;
      }
      previousNewFiber = newFiber;
    }
  }

  // FASE 6: Elimina i vecchi fibers non riutilizzati
  existingChildren.forEach(child => deleteChild(returnFiber, child));

  return resultingFirstChild;
}
```

### Algoritmo di Placement (Riordino)

```javascript
function placeChild(newFiber, lastPlacedIndex, newIndex) {
  newFiber.index = newIndex;

  const current = newFiber.alternate;
  if (current !== null) {
    const oldIndex = current.index;
    if (oldIndex < lastPlacedIndex) {
      // Questo elemento si è mosso indietro, marca per spostamento
      newFiber.flags |= Placement;
      return lastPlacedIndex;
    } else {
      // Elemento nella posizione corretta o avanti
      return oldIndex;
    }
  } else {
    // Nuovo elemento, inseriscilo
    newFiber.flags |= Placement;
    return lastPlacedIndex;
  }
}
```

---

## Double Buffering

React Fiber usa una tecnica chiamata **double buffering**:

```javascript
// Albero 1: CURRENT TREE (renderizzato)
const currentFiber = {
  type: 'div',
  stateNode: domNode,
  memoizedProps: { className: 'old' },
  alternate: workInProgressFiber  // → punta all'altro albero
}

// Albero 2: WORK-IN-PROGRESS TREE (in costruzione)
const workInProgressFiber = {
  type: 'div',
  stateNode: domNode,  // condivide lo stesso DOM node!
  pendingProps: { className: 'new' },
  alternate: currentFiber  // → punta all'altro albero
}
```

### Vantaggi

1. **Riutilizzo della memoria**: Gli oggetti fiber vengono riutilizzati tra render
2. **Rollback facile**: Se abortisci il lavoro, mantieni il current tree
3. **Comparazione efficiente**: Confronti current con work-in-progress

### Swap degli Alberi

```javascript
function commitRoot(root) {
  const finishedWork = root.current.alternate;

  // Applica tutti i cambiamenti...
  commitAllWork(finishedWork);

  // SWAP! Work-in-progress diventa current
  root.current = finishedWork;
}
```

---

## Effect List

Durante la fase di riconciliazione, React costruisce una **linked list di effetti**:

```javascript
// Durante completeWork, raccogli gli effetti
function completeWork(fiber) {
  // ... lavoro ...

  // Questo fiber ha effetti?
  if (fiber.flags !== NoFlags) {
    if (returnFiber.firstEffect === null) {
      returnFiber.firstEffect = fiber;
    }
    if (returnFiber.lastEffect !== null) {
      returnFiber.lastEffect.nextEffect = fiber;
    }
    returnFiber.lastEffect = fiber;
  }

  // Aggiungi anche gli effetti dei figli
  if (fiber.firstEffect !== null) {
    if (returnFiber.firstEffect === null) {
      returnFiber.firstEffect = fiber.firstEffect;
    }
    if (returnFiber.lastEffect !== null) {
      returnFiber.lastEffect.nextEffect = fiber.firstEffect;
    }
    returnFiber.lastEffect = fiber.lastEffect;
  }
}
```

### Struttura della Effect List

```
Root
  ↓ firstEffect
Fiber A (Placement) → nextEffect → Fiber B (Update) → nextEffect → Fiber C (Deletion)
                                                                      ↑
                                                                   lastEffect
```

### Applicazione degli Effetti

```javascript
function commitAllWork(finishedWork) {
  let nextEffect = finishedWork.firstEffect;

  // Itera attraverso la lista
  while (nextEffect !== null) {
    const effectTag = nextEffect.flags;

    // Applica l'effetto appropriato
    if (effectTag & Placement) {
      commitPlacement(nextEffect);
    }
    if (effectTag & Update) {
      commitUpdate(nextEffect);
    }
    if (effectTag & Deletion) {
      commitDeletion(nextEffect);
    }

    nextEffect = nextEffect.nextEffect;
  }
}
```

---

## Priority e Scheduling

React Fiber introduce un sistema di priorità per gli aggiornamenti.

### Lanes (Corsie di Priorità)

A partire da React 18, React usa un sistema di **lanes** (bitmask a 31 bit):

```javascript
// Priorità più alta → più bassa
const SyncLane = 0b0000000000000000000000000000001;          // 1
const InputContinuousLane = 0b0000000000000000000000000000100; // 4
const DefaultLane = 0b0000000000000000000000000010000;        // 16
const TransitionLane = 0b0000000000000000000000001000000;     // 64
const IdleLane = 0b0100000000000000000000000000000;           // ...
```

### Tipi di Aggiornamenti

```javascript
// 1. SYNC: Deve essere eseguito immediatamente
ReactDOM.flushSync(() => {
  setState(newValue);  // SyncLane
});

// 2. USER INPUT: Alta priorità
<input onChange={e => setState(e.target.value)} />  // InputContinuousLane

// 3. DEFAULT: Aggiornamenti normali
setState(newValue);  // DefaultLane

// 4. TRANSITION: Bassa priorità, può essere interrotto
startTransition(() => {
  setState(newValue);  // TransitionLane
});

// 5. DEFERRED: Priorità molto bassa
useDeferredValue(value);  // IdleLane
```

### Scheduler Algorithm

```javascript
function ensureRootIsScheduled(root) {
  // Determina la priorità più alta del lavoro pendente
  const nextLanes = getNextLanes(root, root.pendingLanes);
  const newCallbackPriority = getHighestPriorityLane(nextLanes);

  // Se non c'è lavoro, esci
  if (nextLanes === NoLanes) {
    return;
  }

  // Lavoro già schedulato con la stessa priorità?
  const existingCallbackPriority = root.callbackPriority;
  if (existingCallbackPriority === newCallbackPriority) {
    return;  // Riusa il callback esistente
  }

  // Cancella il vecchio callback e schedula uno nuovo
  if (existingCallbackNode !== null) {
    cancelCallback(existingCallbackNode);
  }

  // Schedula in base alla priorità
  let newCallbackNode;
  if (newCallbackPriority === SyncLane) {
    // Sincrono: esegui immediatamente
    scheduleSyncCallback(performSyncWorkOnRoot.bind(null, root));
    newCallbackNode = null;
  } else {
    // Asincrono: schedula con il Scheduler
    const schedulerPriorityLevel = lanesToSchedulerPriority(newCallbackPriority);
    newCallbackNode = scheduleCallback(
      schedulerPriorityLevel,
      performConcurrentWorkOnRoot.bind(null, root)
    );
  }

  root.callbackPriority = newCallbackPriority;
  root.callbackNode = newCallbackNode;
}
```

### Time Slicing

```javascript
function workLoopConcurrent() {
  // Continua finché c'è lavoro E non dobbiamo cedere al browser
  while (workInProgress !== null && !shouldYield()) {
    performUnitOfWork(workInProgress);
  }
}

function shouldYield() {
  const currentTime = getCurrentTime();
  // Cedi se:
  // 1. Abbiamo superato il deadline (default 5ms)
  // 2. C'è input dell'utente pendente
  // 3. C'è lavoro a priorità più alta
  return currentTime >= deadline || hasPendingInput() || hasHigherPriorityWork();
}
```

---

## Esempio Pratico

Vediamo un esempio completo di come React processa un aggiornamento:

### Setup Iniziale

```javascript
function Counter() {
  const [count, setCount] = useState(0);

  return (
    <div className="container">
      <h1>Count: {count}</h1>
      <button onClick={() => setCount(count + 1)}>
        Increment
      </button>
    </div>
  );
}
```

### Step-by-Step: Click del Button

#### 1. **Trigger dell'Aggiornamento**

```javascript
// User clicca il button
onClick() → setCount(1)

// React marca il fiber del Counter con un update
counterFiber.lanes |= DefaultLane;
counterFiber.updateQueue.push({ action: 1 });

// Schedula il lavoro
ensureRootIsScheduled(root);
```

#### 2. **Render Phase: Begin Work**

```javascript
// Root fiber
beginWork(rootFiber)
  → Processa Counter fiber

// Counter fiber (FunctionComponent)
beginWork(counterFiber)
  → Chiama Counter()
  → Esegue useState hook → count = 1
  → Ritorna JSX: <div><h1>Count: 1</h1><button>...</button></div>
  → Crea fibers per div, h1, button

// div fiber (HostComponent)
beginWork(divFiber)
  → Props: { className: "container" }
  → Crea fibers per i children (h1, button)

// h1 fiber (HostComponent)
beginWork(h1Fiber)
  → Props: {}
  → Crea fiber per il testo: "Count: 1"
  → L'h1 esistente aveva "Count: 0"
  → Props cambiate? No
  → Content cambiato? Sì! → flags |= Update

// Text fiber
beginWork(textFiber)
  → textContent: "Count: 1"
  → previous: "Count: 0"
  → Different! → flags |= Update

// button fiber
beginWork(buttonFiber)
  → Props: { onClick: [Function] }
  → Controlla props precedenti... uguali!
  → Bailout (skip subtree)
```

#### 3. **Render Phase: Complete Work**

```javascript
// Risalendo l'albero...

completeWork(textFiber)
  → flags: Update
  → Aggiungi a effect list del parent

completeWork(h1Fiber)
  → Raccogli effetti dei figli
  → effect list: textFiber

completeWork(buttonFiber)
  → Nessun cambiamento, nessun effetto

completeWork(divFiber)
  → Raccogli effetti dei figli
  → effect list: textFiber

completeWork(counterFiber)
  → Raccogli effetti dei figli
  → effect list: textFiber

completeWork(rootFiber)
  → effect list completa: textFiber
```

#### 4. **Commit Phase**

```javascript
// Before Mutation
commitBeforeMutationEffects()
  → Schedula useEffect per dopo

// Mutation
commitMutationEffects()
  → textFiber.flags & Update
  → commitUpdate(textFiber)
    → textNode.nodeValue = "Count: 1"

// Layout
commitLayoutEffects()
  → Nessun componentDidMount/Update
  → Nessun useLayoutEffect in questo caso
```

#### 5. **Finalization**

```javascript
// Swap degli alberi
root.current = finishedWork;

// Schedula useEffect
schedulePassiveEffects();

// Cleanup
workInProgress = null;
```

### Albero dei Fiber Risultante

```
RootFiber (current)
  ↓
Counter
  ↓
div.container
  ├→ h1
  │   ↓
  │  "Count: 1" ← AGGIORNATO
  │
  └→ button
      ↓
     "Increment"
```

---

## Best Practices

### 1. Usa le Key Correttamente

```javascript
// ❌ MALE: Usa l'index come key
{items.map((item, index) => <Item key={index} {...item} />)}

// ✅ BENE: Usa un ID stabile
{items.map(item => <Item key={item.id} {...item} />)}
```

### 2. Mantieni i Componenti Puri

```javascript
// ❌ MALE: Side effects nel render
function Component() {
  document.title = "New title";  // Side effect!
  return <div>...</div>;
}

// ✅ BENE: Side effects in useEffect
function Component() {
  useEffect(() => {
    document.title = "New title";
  }, []);
  return <div>...</div>;
}
```

### 3. Usa React.memo per Ottimizzazioni

```javascript
const ExpensiveComponent = React.memo(({ data }) => {
  // Render solo se data cambia
  return <div>{/* expensive render */}</div>;
});
```

### 4. Usa startTransition per Aggiornamenti Non Urgenti

```javascript
import { startTransition } from 'react';

function SearchResults() {
  const [input, setInput] = useState('');
  const [results, setResults] = useState([]);

  const handleChange = (e) => {
    // Aggiornamento urgente
    setInput(e.target.value);

    // Aggiornamento non urgente
    startTransition(() => {
      setResults(search(e.target.value));
    });
  };

  return (/* ... */);
}
```

---

## Risorse

- [React Fiber Architecture (GitHub)](https://github.com/acdlite/react-fiber-architecture)
- [React Source Code](https://github.com/facebook/react)
- [React Reconciliation Docs](https://react.dev/learn/preserving-and-resetting-state)
- [Inside Fiber: in-depth overview (YouTube)](https://www.youtube.com/watch?v=ZCuYPiUIONs)

---

## Conclusione

React Fiber è un'architettura sofisticata che permette:

✅ **Rendering interrompibile** - Il lavoro può essere diviso in chunk
✅ **Prioritizzazione** - Gli aggiornamenti urgenti non vengono bloccati
✅ **Riutilizzo del lavoro** - Bailout quando possibile
✅ **Concorrenza** - Prepara più versioni dell'UI contemporaneamente
✅ **Scheduling intelligente** - Time slicing per mantenere l'UI responsive

Comprendere Fiber ti aiuta a:
- Scrivere componenti più performanti
- Debuggare problemi di rendering
- Usare le nuove feature (Suspense, Transitions, etc.)
- Implementare sistemi simili (come il tuo SwiftWeb!)
