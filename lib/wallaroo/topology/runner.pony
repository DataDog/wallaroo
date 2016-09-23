use "buffered"
use "time"
use "net"
use "sendence/epoch"
use "wallaroo/metrics"

interface Runner
  fun ref run[In: Any val](metric_name: String, source_ts: U64, input: In)

class ComputationRunner[In: Any val, Out: Any val]
  let _computation: Computation[In, Out] val
  let _computation_name: String
  let _target: Step tag
  let _metrics_reporter: MetricsReporter

  new iso create(computation: Computation[In, Out] val, 
    target: Step tag,
    metrics_reporter: MetricsReporter iso) 
  =>
    _computation = computation
    _computation_name = _computation.name()
    _target = target
    _metrics_reporter = consume metrics_reporter

  fun ref run[D: Any val](source_name: String val, source_ts: U64, input: D) 
  =>
    let computation_start = Time.nanos()
    match input
    | let i: In =>
      match _computation(i)
      | let output: Out =>
        _target.run[Out](source_name, source_ts, output)
      else
        _metrics_reporter.pipeline_metric(source_name, source_ts)
      end

      let computation_end = Time.nanos()   

      _metrics_reporter.step_metric(_computation_name,
        computation_start, computation_end)
    end

class StateRunner[State: Any #read]
  let _state: State
  let _metrics_reporter: MetricsReporter
  let _wb: Writer = Writer

  new iso create(state_builder: {(): State} val, 
    metrics_reporter: MetricsReporter iso) 
  =>
    _state = state_builder()
    _metrics_reporter = consume metrics_reporter

  fun ref run[In: Any val](source_name: String val, source_ts: U64, input: In) =>
    match input
    | let sp: StateProcessor[State] val =>
      let computation_start = Time.nanos()
      sp(_state, _wb)
      let computation_end = Time.nanos()

      _metrics_reporter.pipeline_metric(source_name, source_ts)

      _metrics_reporter.step_metric(sp.name(),
        computation_start, computation_end)
    else
      @printf[I32]("StateRunner: Input was not a StateProcessor!\n".cstring())
    end

class SimpleSink
  let _metrics_reporter: MetricsReporter

  new iso create(metrics_reporter: MetricsReporter iso) =>
    _metrics_reporter = consume metrics_reporter

  fun ref run[In: Any val](metric_name: String, source_ts: U64, input: In) =>
    match input
    | let s: Stringable val =>
      @printf[I32](("Simple sink: Received " + s.string() + "\n").cstring())
    else
      @printf[I32]("Simple sink: Got it!\n".cstring())
    end

    _metrics_reporter.pipeline_metric(metric_name, source_ts)

class EncoderSink//[Out: Any val]
  let _metrics_reporter: MetricsReporter
  let _conn: TCPConnection
  // let _encoder: {(Out): Array[ByteSeq] val} val

  new iso create(metrics_reporter: MetricsReporter iso,
    conn: TCPConnection)
  // , encoder: {(Out): Array[ByteSeq] val} val)
  =>
    _metrics_reporter = consume metrics_reporter
    _conn = conn
    // _encoder = encoder

  fun ref run[In: Any val](metric_name: String, source_ts: U64, input: In) =>
    _conn.write("hi")
    // match input
    // | let o: Out =>
      // let encoded = _encoder(o)
    // end

    _metrics_reporter.pipeline_metric(metric_name, source_ts)
