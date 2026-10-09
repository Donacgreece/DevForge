import type {Problem} from './problems'
export type TestResult={pass:boolean,args:unknown[],expected:unknown,actual?:unknown,error?:string}
export type RunResult={results:TestResult[],error?:string}
// DEV DEMO ONLY: a dedicated Worker prevents UI blocking but is NOT a secure JS sandbox.
// Never run arbitrary user code in the main app or trust this for server-side grading.
export function evaluate(problem:Problem, code:string, timeout=1800):Promise<RunResult>{
 return new Promise(resolve=>{
  const source=`self.onmessage = (ev) => {\n try {\n const make = new Function('"use strict";\\n' + ev.data.code + '\\n;return typeof solve === "function" ? solve : null');\n const fn = make();\n if (!fn) throw Error('Define function solve');\n const results=ev.data.tests.map(t=>{try{const value=fn(...structuredClone(t.args));return {args:t.args,expected:t.expected,actual:value,pass:JSON.stringify(value)===JSON.stringify(t.expected)}}catch(e){return {args:t.args,expected:t.expected,pass:false,error:String(e)}}});\n self.postMessage({results});\n }catch(e){self.postMessage({results:[],error:String(e)})}\n}`
  const url=URL.createObjectURL(new Blob([source],{type:'text/javascript'}))
  const worker=new Worker(url)
  let finished=false
  const finish=(data:RunResult)=>{if(finished)return;finished=true;clearTimeout(timer);worker.terminate();URL.revokeObjectURL(url);resolve(data)}
  const timer=setTimeout(()=>finish({results:[],error:'Execution timed out / Υπέρβαση χρόνου'}),timeout)
  worker.onmessage=e=>finish(e.data as RunResult)
  worker.onerror=e=>finish({results:[],error:e.message || 'Worker failed'})
  worker.postMessage({code,tests:problem.tests})
 })
}
