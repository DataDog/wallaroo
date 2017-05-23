use "collections"
use "net"
use "time"
use "sendence/guid"
use "wallaroo/fail"
use "wallaroo/messages"
use "wallaroo/metrics"
use "wallaroo/network"
use "wallaroo/tcp_sink"
use "wallaroo/tcp_source"
use "wallaroo/recovery"
use "wallaroo/routing"
use "wallaroo/topology"

primitive Act
primitive Finish

class ActorSystem
  let _name: String
  let _seed: U64
  let _guid: GuidGenerator
  let _actor_builders: Array[WActorWrapperBuilder] = _actor_builders.create()
  let _sources: Array[(WActorFramedSourceHandler, WActorRouter)] =
    _sources.create()
  let _sinks: Array[TCPSinkBuilder] = _sinks.create()

  new create(name': String, seed': U64 = Time.micros()) =>
    _name = name'
    _seed = seed'
    _guid = GuidGenerator(_seed)

  fun name(): String => _name
  fun seed(): U64 => _seed

  fun ref add_actor(builder: WActorBuilder) =>
    let next = StatefulWActorWrapperBuilder(_guid.u128(), builder)
    _actor_builders.push(next)

  fun ref add_actors(builders: Array[WActorBuilder]) =>
    for b in builders.values() do
      add_actor(b)
    end

  fun ref add_source(handler: WActorFramedSourceHandler,
    actor_router: WActorRouter)
  =>
    _sources.push((handler, actor_router))

  // TODO: Figure out why this failed to get passed "Reachability"
  // when compiling if you use .> but not if you use .
  fun ref add_sink[Out: Any val](encoder: SinkEncoder[Out],
    initial_msgs: Array[Array[ByteSeq] val] val
      = recover Array[Array[ByteSeq] val] end): ActorSystem
  =>
    let builder = TCPSinkBuilder(TypedEncoderWrapper[Out](encoder),
      initial_msgs)
    _sinks.push(builder)
    this

  fun val actor_builders(): Array[WActorWrapperBuilder] val =>
    _actor_builders

  fun val sources(): Array[(WActorFramedSourceHandler, WActorRouter)] val =>
    _sources

  fun val sinks(): Array[TCPSinkBuilder] val =>
    _sinks

class val LocalActorSystem
  let _name: String
  let _actor_builders: Array[WActorWrapperBuilder] val
  let _sources: Array[(WActorFramedSourceHandler, WActorRouter)] val
  let _sinks: Array[TCPSinkBuilder] val

  new val create(name': String,
    actor_builders': Array[WActorWrapperBuilder] val,
    sources': Array[(WActorFramedSourceHandler, WActorRouter)] val,
    sinks': Array[TCPSinkBuilder] val)
  =>
    _name = name'
    _actor_builders = actor_builders'
    _sources = sources'
    _sinks = sinks'

  fun name(): String => _name

  fun add_actor(builder: WActorWrapperBuilder): LocalActorSystem =>
    //TODO: Use persistent vector once it's available to improve perf here
    let arr: Array[WActorWrapperBuilder] trn =
      recover Array[WActorWrapperBuilder] end
    for a in _actor_builders.values() do
      arr.push(a)
    end
    arr.push(builder)
    LocalActorSystem(_name, consume arr, _sources, _sinks)

  fun actor_builders(): Array[WActorWrapperBuilder] val =>
    _actor_builders

  fun sources(): Array[(WActorFramedSourceHandler, WActorRouter)] val =>
    _sources

  fun sinks(): Array[TCPSinkBuilder] val =>
    _sinks