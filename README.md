# Super-POM 超级POM项目

用于在项目上定义约束，以满足项目稳定、安全构建投产。
背景[使用Maven Enforcer Plugin提升构建稳定性](Maven-Enforcer.md)。
基于[Maven Enforcer Plugin](Maven-Enforcer.md)构建的约束规则。

1. 禁止引入冲突的依赖
2. 约束多模块项目
3. 其他经典约定：编码、运行时版本等
4. 依赖管理最佳实践(可选)
5. 重复类检测
6. 禁止循环依赖
7. 使用[OSS Index REST API v2.0](https://ossindex.net)进行依赖安全审计，报告存在缺陷的依赖

## 效果

### 验证是否违规

```text
[INFO] Scanning for projects...
[WARNING] 
[WARNING] Some problems were encountered while building the effective model for com.youzan.i.hujixu:bad-child:jar:1.0.2
[WARNING] 'dependencies.dependency.(groupId:artifactId:type:classifier)' must be unique: com.google.guava:guava:jar -> version 18.0 vs 17.0 @ line 39, column 15
[WARNING] 
[WARNING] It is highly recommended to fix these problems because they threaten the stability of your build.
[WARNING] 
[WARNING] For this reason, future Maven versions might no longer support building such malformed projects.
[WARNING] 
[INFO] ------------------------------------------------------------------------
[INFO] Reactor Build Order:
[INFO] 
[INFO] multi-module-demo
[INFO] bad-child
[INFO] framework-bom
[INFO] bom-demo
[INFO]                                                                         
[INFO] ------------------------------------------------------------------------
[INFO] Building multi-module-demo 1.0.1
[INFO] ------------------------------------------------------------------------
[INFO] 
[INFO] --- maven-enforcer-plugin:3.0.0-M2:enforce (default-enforcer) @ multi-module-demo ---
[WARNING] Rule 2: org.apache.maven.plugins.enforcer.ReactorModuleConvergence failed with message:
The reactor contains different versions.
[WARNING][Enforcer] 多模块项目子模块需要保持版本号相同（建议不要显式设置子模块版本号，从parent继承）
 --> com.youzan.i.hujixu:bad-child:jar:1.0.2

[INFO] ------------------------------------------------------------------------
[INFO] Reactor Summary:
[INFO] 
[INFO] multi-module-demo .................................. FAILURE [  0.782 s]
[INFO] bad-child .......................................... SKIPPED
[INFO] framework-bom ...................................... SKIPPED
[INFO] bom-demo ........................................... SKIPPED
[INFO] ------------------------------------------------------------------------
[INFO] BUILD FAILURE
[INFO] ------------------------------------------------------------------------
[INFO] Total time: 0.988 s
[INFO] Finished at: 2018-07-04T09:56:55+08:00
[INFO] Final Memory: 9M/155M
[INFO] ------------------------------------------------------------------------
[ERROR] Failed to execute goal org.apache.maven.plugins:maven-enforcer-plugin:3.0.0-M2:enforce (default-enforcer) on project multi-module-demo: Some Enforcer rules have failed. Look above for specific messages explaining why the rule failed. -> [Help 1]
[ERROR] 
[ERROR] To see the full stack trace of the errors, re-run Maven with the -e switch.
[ERROR] Re-run Maven using the -X switch to enable full debug logging.
[ERROR] 
[ERROR] For more information about the errors and possible solutions, please read the following articles:
[ERROR] [Help 1] http://cwiki.apache.org/confluence/display/MAVEN/MojoExecutionException

```


### 查看全部违规

```text
[INFO] Scanning for projects...
[WARNING] 
[WARNING] Some problems were encountered while building the effective model for com.youzan.i.hujixu:bad-child:jar:1.0.2
[WARNING] 'dependencies.dependency.(groupId:artifactId:type:classifier)' must be unique: com.google.guava:guava:jar -> version 18.0 vs 17.0 @ line 39, column 15
[WARNING] 
[WARNING] It is highly recommended to fix these problems because they threaten the stability of your build.
[WARNING] 
[WARNING] For this reason, future Maven versions might no longer support building such malformed projects.
[WARNING] 
[INFO] ------------------------------------------------------------------------
[INFO] Reactor Build Order:
[INFO] 
[INFO] multi-module-demo
[INFO] bad-child
[INFO] framework-bom
[INFO] bom-demo
[INFO]                                                                         
[INFO] ------------------------------------------------------------------------
[INFO] Building multi-module-demo 1.0.1
[INFO] ------------------------------------------------------------------------
[INFO] 
[INFO] --- maven-enforcer-plugin:3.0.0-M2:enforce (default-enforcer) @ multi-module-demo ---
[WARNING] Rule 2: org.apache.maven.plugins.enforcer.ReactorModuleConvergence failed with message:
The reactor contains different versions.
[WARNING][Enforcer] 多模块项目子模块需要保持版本号相同（建议不要显式设置子模块版本号，从parent继承）
 --> com.youzan.i.hujixu:bad-child:jar:1.0.2

[INFO] 
[INFO] --- maven-enforcer-plugin:3.0.0-M2:enforce (blacklist-struts-dependencies) @ multi-module-demo ---
[INFO] 
[INFO] --- maven-enforcer-plugin:3.0.0-M2:enforce (force-guava-versions) @ multi-module-demo ---
[INFO] 
[INFO] --- maven-enforcer-plugin:3.0.0-M2:enforce (duplicate-class) @ multi-module-demo ---
[INFO] Adding ignore: module-info
[INFO] Adding ignore: META-INF/versions/*/module-info
[INFO] Adding ignore: *.R
[INFO] Adding ignore: org.apache.commons.logging.*
[INFO] 
[INFO] --- ossindex-maven-plugin:2.3.7:audit (default-audit) @ multi-module-demo ---
[INFO] OSS Index dependency audit
[INFO]                                                                         
[INFO] ------------------------------------------------------------------------
[INFO] Building bad-child 1.0.2
[INFO] ------------------------------------------------------------------------
[INFO] 
[INFO] --- maven-enforcer-plugin:3.0.0-M2:enforce (default-enforcer) @ bad-child ---
[WARNING] 
Dependency convergence error for org.slf4j:slf4j-api:1.7.25 paths to dependency are:
+-com.youzan.i.hujixu:bad-child:1.0.2
  +-org.slf4j:slf4j-api:1.7.25
and
+-com.youzan.i.hujixu:bad-child:1.0.2
  +-ch.qos.logback:logback-classic:1.2.2
    +-org.slf4j:slf4j-api:1.7.25
and
+-com.youzan.i.hujixu:bad-child:1.0.2
  +-org.slf4j:slf4j-log4j12:1.7.16
    +-org.slf4j:slf4j-api:1.7.16

[WARNING] Rule 0: org.apache.maven.plugins.enforcer.BanDuplicatePomDependencyVersions failed with message:
Found 1 duplicate dependency declaration in this project:
 - dependencies.dependency[com.google.guava:guava:jar] ( 2 times )

[WARNING] Rule 1: org.apache.maven.plugins.enforcer.DependencyConvergence failed with message:
Failed while enforcing releasability. See above detailed error message.
[WARNING] Rule 2: org.apache.maven.plugins.enforcer.ReactorModuleConvergence failed with message:
The reactor contains different versions.
[WARNING][Enforcer] 多模块项目子模块需要保持版本号相同（建议不要显式设置子模块版本号，从parent继承）
 --> com.youzan.i.hujixu:bad-child:jar:1.0.2

[WARNING] Rule 4: org.apache.maven.plugins.enforcer.EvaluateBeanshell failed with message:
[WARNING][Enforcer] 请使用utf-8编码:<encoding>utf-8<encoding>
[WARNING] Rule 5: org.apache.maven.plugins.enforcer.EvaluateBeanshell failed with message:
[WARNING][Enforcer] 请不要单独配置<file.encoding>，只需要配置<encoding>utf-8<encoding>
[INFO] 
[INFO] --- maven-enforcer-plugin:3.0.0-M2:enforce (blacklist-struts-dependencies) @ bad-child ---
[WARNING] Rule 0: org.apache.maven.plugins.enforcer.BannedDependencies failed with message:
[WARNING][Enforcer] Struts [2.1.1,2.5.14.1] is banned for security issue https://cwiki.apache.org/confluence/display/WW/S2-056
Found Banned Dependency: org.apache.struts:struts2-core:jar:2.5.14.1
Use 'mvn dependency:tree' to locate the source of the banned dependencies.
[INFO] 
[INFO] --- maven-enforcer-plugin:3.0.0-M2:enforce (force-guava-versions) @ bad-child ---
[WARNING] Rule 0: org.apache.maven.plugins.enforcer.BannedDependencies failed with message:
[WARNING][Enforcer] Only Guava 19.0 allowed
Found Banned Dependency: com.google.guava:guava:jar:17.0
Use 'mvn dependency:tree' to locate the source of the banned dependencies.
[INFO] 
[INFO] --- maven-enforcer-plugin:3.0.0-M2:enforce (duplicate-class) @ bad-child ---
[INFO] Adding ignore: module-info
[INFO] Adding ignore: META-INF/versions/*/module-info
[INFO] Adding ignore: *.R
[INFO] Adding ignore: org.apache.commons.logging.*
[WARNING] Rule 0: org.apache.maven.plugins.enforcer.BanDuplicateClasses failed with message:
Duplicate classes found:

  Found in:
    io.netty:netty:jar:3.7.0.Final:compile
    org.jboss.netty:netty:jar:3.2.2.Final:compile
  Duplicate classes:
    org/jboss/netty/channel/socket/ServerSocketChannelConfig.class
    org/jboss/netty/channel/socket/nio/NioSocketChannelConfig.class
    org/jboss/netty/util/internal/jzlib/Deflate.class
    org/jboss/netty/handler/codec/serialization/ObjectDecoder.class
    org/jboss/netty/util/internal/ConcurrentHashMap$HashIterator.class
    org/jboss/netty/util/internal/jzlib/Tree.class
    org/jboss/netty/util/internal/ConcurrentIdentityWeakKeyHashMap$Segment.class
    org/jboss/netty/handler/logging/LoggingHandler.class
    org/jboss/netty/channel/ChannelHandlerLifeCycleException.class
    org/jboss/netty/util/internal/ConcurrentIdentityHashMap$ValueIterator.class
    org/jboss/netty/util/internal/ConcurrentIdentityWeakKeyHashMap$Values.class
    org/jboss/netty/util/internal/UnterminatableExecutor.class
    org/jboss/netty/handler/codec/compression/ZlibDecoder.class
    org/jboss/netty/handler/codec/rtsp/RtspHeaders$Values.class
    org/jboss/netty/handler/codec/replay/ReplayError.class
    org/jboss/netty/buffer/HeapChannelBufferFactory.class
    org/jboss/netty/channel/DefaultChannelPipeline$DiscardingChannelSink.class
    org/jboss/netty/channel/socket/oio/OioClientSocketPipelineSink$1.class
    org/jboss/netty/buffer/ChannelBufferIndexFinder.class
    org/jboss/netty/channel/local/DefaultLocalServerChannelFactory.class
    org/jboss/netty/channel/LifeCycleAwareChannelHandler.class
    org/jboss/netty/handler/codec/http/HttpContentDecoder.class
    org/jboss/netty/util/internal/ConcurrentWeakKeyHashMap$WriteThroughEntry.class
    org/jboss/netty/handler/codec/compression/ZlibUtil$1.class
    org/jboss/netty/handler/codec/frame/TooLongFrameException.class
    org/jboss/netty/handler/codec/serialization/SwitchableInputStream.class
    org/jboss/netty/handler/codec/http/HttpMessageEncoder.class
    org/jboss/netty/channel/DefaultWriteCompletionEvent.class
    org/jboss/netty/channel/socket/oio/OioServerSocketChannel.class
    org/jboss/netty/handler/stream/ChunkedInput.class
    org/jboss/netty/channel/local/LocalServerChannel.class
    org/jboss/netty/handler/codec/frame/LengthFieldPrepender.class
    org/jboss/netty/handler/codec/http/DefaultHttpResponse.class
    org/jboss/netty/handler/codec/http/websocket/WebSocketFrameDecoder.class
    org/jboss/netty/buffer/ChannelBufferIndexFinder$9.class
    org/jboss/netty/logging/CommonsLogger.class
    org/jboss/netty/util/internal/ConcurrentIdentityHashMap$Segment.class
    org/jboss/netty/util/internal/ConcurrentIdentityWeakKeyHashMap$KeyIterator.class
    org/jboss/netty/util/internal/StringUtil.class
    org/jboss/netty/buffer/ChannelBuffer.class
    org/jboss/netty/buffer/ReadOnlyChannelBuffer.class
    org/jboss/netty/channel/local/LocalServerChannelFactory.class
    org/jboss/netty/util/internal/ConcurrentWeakKeyHashMap$Segment.class
    org/jboss/netty/channel/socket/ClientSocketChannelFactory.class
    org/jboss/netty/channel/ChannelLocal.class
    org/jboss/netty/handler/codec/http/HttpClientCodec$Encoder.class
    org/jboss/netty/handler/codec/http/DefaultCookie.class
    org/jboss/netty/handler/codec/protobuf/ProtobufVarint32FrameDecoder.class
    org/jboss/netty/channel/AbstractChannelSink.class
    org/jboss/netty/channel/socket/nio/NioSocketChannel.class
    org/jboss/netty/channel/ChannelHandler.class
    org/jboss/netty/util/MapBackedSet.class
    org/jboss/netty/channel/socket/http/HttpTunnelingClientSocketChannel$7.class
    org/jboss/netty/handler/codec/http/Cookie.class
    org/jboss/netty/channel/socket/oio/OioClientSocketChannelFactory.class
    org/jboss/netty/buffer/DuplicatedChannelBuffer.class
    org/jboss/netty/handler/codec/http/DefaultHttpChunkTrailer$1.class
    org/jboss/netty/handler/codec/http/HttpRequestDecoder.class
    org/jboss/netty/handler/codec/http/HttpVersion.class
    org/jboss/netty/util/internal/ConcurrentIdentityWeakKeyHashMap$EntrySet.class
    org/jboss/netty/channel/AdaptiveReceiveBufferSizePredictor.class
    org/jboss/netty/handler/timeout/IdleStateHandler$WriterIdleTimeoutTask.class
    org/jboss/netty/channel/ChannelException.class
    org/jboss/netty/handler/codec/compression/ZlibWrapper.class
    org/jboss/netty/channel/socket/oio/OioWorker.class
    org/jboss/netty/util/internal/ConcurrentIdentityWeakKeyHashMap$SimpleEntry.class
    org/jboss/netty/channel/WriteCompletionEvent.class
    org/jboss/netty/buffer/CompositeChannelBuffer.class
    org/jboss/netty/handler/execution/MemoryAwareThreadPoolExecutor$MemoryAwareRunnable.class
    org/jboss/netty/logging/CommonsLoggerFactory.class
    org/jboss/netty/util/internal/ConversionUtil.class
    org/jboss/netty/handler/timeout/WriteTimeoutHandler.class
    org/jboss/netty/util/HashedWheelTimer$Worker.class
    org/jboss/netty/handler/codec/compression/ZlibUtil.class
    org/jboss/netty/util/internal/jzlib/Deflate$1.class
    org/jboss/netty/handler/ssl/SslHandler$2.class
    org/jboss/netty/channel/socket/http/HttpTunnelingClientSocketChannel$2.class
    org/jboss/netty/handler/timeout/ReadTimeoutHandler$ReadTimeoutTask.class
    org/jboss/netty/util/internal/ConcurrentIdentityHashMap$EntryIterator.class
    org/jboss/netty/handler/codec/http/HttpChunkAggregator.class
    org/jboss/netty/channel/ChannelPipelineException.class
    org/jboss/netty/channel/socket/oio/OioClientSocketChannel.class
    org/jboss/netty/channel/ChannelSink.class
    org/jboss/netty/channel/socket/http/HttpTunnelingClientSocketChannel$5.class
    org/jboss/netty/channel/DefaultChannelPipeline.class
    org/jboss/netty/util/ThreadNameDeterminer$1.class
    org/jboss/netty/channel/socket/http/HttpTunnelingClientSocketChannelFactory.class
    org/jboss/netty/channel/socket/nio/NioClientSocketPipelineSink.class
    org/jboss/netty/handler/codec/http/CookieDateFormat.class
    org/jboss/netty/util/internal/jzlib/ZStream.class
    org/jboss/netty/channel/group/DefaultChannelGroup.class
    org/jboss/netty/channel/StaticChannelPipeline$StaticChannelHandlerContext.class
    org/jboss/netty/channel/ChannelHandlerContext.class
    org/jboss/netty/bootstrap/ServerBootstrap$Binder.class
    org/jboss/netty/handler/codec/frame/CorruptedFrameException.class
    org/jboss/netty/handler/codec/rtsp/RtspResponseDecoder.class
    org/jboss/netty/handler/codec/base64/Base64Decoder.class
    org/jboss/netty/util/internal/jzlib/Inflate$1.class
    org/jboss/netty/buffer/LittleEndianHeapChannelBuffer.class
    org/jboss/netty/bootstrap/ServerBootstrap.class
    org/jboss/netty/handler/codec/rtsp/RtspResponseStatuses.class
    org/jboss/netty/channel/socket/http/HttpTunnelingClientSocketPipelineSink.class
    org/jboss/netty/handler/codec/http/HttpContentEncoder.class
    org/jboss/netty/util/internal/ConcurrentIdentityHashMap$WriteThroughEntry.class
    org/jboss/netty/util/internal/ConcurrentHashMap$Values.class
    org/jboss/netty/util/internal/ConcurrentWeakKeyHashMap.class
    org/jboss/netty/util/internal/ConcurrentHashMap$KeySet.class
    org/jboss/netty/channel/ChannelConfig.class
    org/jboss/netty/handler/codec/http/QueryStringEncoder.class
    org/jboss/netty/buffer/ChannelBufferOutputStream.class
    org/jboss/netty/handler/codec/http/DefaultHttpChunkTrailer.class
    org/jboss/netty/logging/AbstractInternalLogger$1.class
    org/jboss/netty/channel/ChildChannelStateEvent.class
    org/jboss/netty/handler/codec/http/HttpResponse.class
    org/jboss/netty/channel/socket/nio/SocketSendBufferPool$Preallocation.class
    org/jboss/netty/handler/codec/serialization/CompatibleObjectDecoder$1.class
    org/jboss/netty/handler/codec/http/HttpHeaders.class
    org/jboss/netty/handler/codec/http/HttpContentCompressor.class
    org/jboss/netty/handler/codec/compression/ZlibEncoder$2.class
    org/jboss/netty/channel/DefaultExceptionEvent.class
    org/jboss/netty/channel/socket/nio/DefaultNioSocketChannelConfig.class
    org/jboss/netty/handler/ssl/SslBufferPool.class
    org/jboss/netty/handler/ssl/ImmediateExecutor.class
    org/jboss/netty/handler/codec/serialization/CompatibleObjectDecoderState.class
    org/jboss/netty/channel/socket/http/HttpTunnelingClientSocketChannel$3.class
    org/jboss/netty/handler/codec/compression/ZlibEncoder.class
    org/jboss/netty/handler/codec/http/HttpClientCodec.class
    org/jboss/netty/channel/socket/nio/NioWorker.class
    org/jboss/netty/channel/socket/nio/SocketSendBufferPool$SendBuffer.class
    org/jboss/netty/handler/codec/replay/ReplayingDecoderBuffer.class
    org/jboss/netty/util/internal/ConcurrentHashMap$EntrySet.class
    org/jboss/netty/handler/codec/http/HttpContentCompressor$1.class
    org/jboss/netty/handler/timeout/WriteTimeoutHandler$TimeoutCanceller.class
    org/jboss/netty/handler/codec/rtsp/RtspResponseEncoder.class
    org/jboss/netty/handler/timeout/WriteTimeoutException.class
    org/jboss/netty/util/internal/ThreadLocalRandom$1.class
    org/jboss/netty/handler/codec/http/websocket/DefaultWebSocketFrame.class
    org/jboss/netty/buffer/ChannelBufferIndexFinder$6.class
    org/jboss/netty/util/internal/ConcurrentWeakKeyHashMap$EntrySet.class
    org/jboss/netty/util/internal/jzlib/InfCodes.class
    org/jboss/netty/buffer/BigEndianHeapChannelBuffer.class
    org/jboss/netty/handler/codec/http/websocket/WebSocketFrameEncoder.class
    org/jboss/netty/handler/queue/BlockingReadTimeoutException.class
    org/jboss/netty/util/internal/jzlib/Inflate.class
    org/jboss/netty/handler/codec/serialization/ObjectEncoderOutputStream.class
    org/jboss/netty/channel/socket/nio/NioServerSocketPipelineSink$1.class
    org/jboss/netty/handler/codec/http/HttpCodecUtil.class
    org/jboss/netty/logging/InternalLogger.class
    org/jboss/netty/handler/codec/rtsp/RtspMethods.class
    org/jboss/netty/handler/timeout/IdleStateHandler$AllIdleTimeoutTask.class
    org/jboss/netty/channel/group/DefaultChannelGroupFuture$1.class
    org/jboss/netty/handler/queue/BufferedWriteHandler$1.class
    org/jboss/netty/channel/socket/nio/NioClientSocketPipelineSink$1.class
    org/jboss/netty/channel/StaticChannelPipeline.class
    org/jboss/netty/channel/socket/nio/NioDatagramChannel.class
    org/jboss/netty/handler/codec/replay/UnsafeDynamicChannelBuffer.class
    org/jboss/netty/handler/timeout/ReadTimeoutException.class
    org/jboss/netty/buffer/ChannelBufferIndexFinder$7.class
    org/jboss/netty/channel/AbstractChannel$ChannelCloseFuture.class
    org/jboss/netty/channel/socket/DefaultSocketChannelConfig.class
    org/jboss/netty/handler/stream/ChunkedNioStream.class
    org/jboss/netty/channel/ChannelFactory.class
    org/jboss/netty/handler/codec/embedder/EmbeddedSocketAddress.class
    org/jboss/netty/handler/codec/string/StringEncoder.class
    org/jboss/netty/logging/Log4JLoggerFactory.class
    org/jboss/netty/channel/socket/nio/NioClientSocketPipelineSink$2.class
    org/jboss/netty/channel/socket/oio/OioServerSocketPipelineSink.class
    org/jboss/netty/handler/timeout/IdleStateAwareChannelHandler.class
    org/jboss/netty/util/internal/jzlib/ZStream$1.class
    org/jboss/netty/util/internal/jzlib/JZlib.class
    org/jboss/netty/util/internal/ConcurrentIdentityHashMap$KeySet.class
    org/jboss/netty/util/ThreadNameDeterminer$2.class
    org/jboss/netty/channel/socket/nio/NioClientSocketChannel.class
    org/jboss/netty/handler/codec/http/HttpResponseEncoder.class
    org/jboss/netty/util/internal/jzlib/Deflate$Config.class
    org/jboss/netty/channel/socket/http/HttpTunnelingClientSocketPipelineSink$1.class
    org/jboss/netty/handler/queue/BufferedWriteHandler.class
    org/jboss/netty/buffer/ChannelBufferIndexFinder$1.class
    org/jboss/netty/handler/codec/embedder/AbstractCodecEmbedder$EmbeddedChannelPipeline.class
    org/jboss/netty/util/internal/ConcurrentWeakKeyHashMap$SimpleEntry.class
    org/jboss/netty/channel/DefaultFileRegion.class
    org/jboss/netty/util/ObjectSizeEstimator.class
    org/jboss/netty/channel/socket/nio/NioDatagramPipelineSink.class
    org/jboss/netty/handler/codec/http/websocket/WebSocketFrame.class
    org/jboss/netty/channel/socket/DatagramChannelFactory.class
    org/jboss/netty/util/Version.class
    org/jboss/netty/util/internal/ConcurrentWeakKeyHashMap$Values.class
    org/jboss/netty/util/internal/ThreadLocalBoolean.class
    org/jboss/netty/util/VirtualExecutorService$ChildExecutorRunnable.class
    org/jboss/netty/channel/Channels$1.class
    org/jboss/netty/channel/SimpleChannelDownstreamHandler$1.class
    org/jboss/netty/channel/SimpleChannelHandler.class
    org/jboss/netty/util/internal/ThreadLocalRandom.class
    org/jboss/netty/buffer/ChannelBufferIndexFinder$2.class
    org/jboss/netty/logging/InternalLoggerFactory$1.class
    org/jboss/netty/channel/DefaultChannelPipeline$DefaultChannelHandlerContext.class
    org/jboss/netty/channel/socket/nio/SocketSendBufferPool$EmptySendBuffer.class
    org/jboss/netty/channel/socket/oio/OioDatagramPipelineSink.class
    org/jboss/netty/handler/codec/oneone/OneToOneEncoder.class
    org/jboss/netty/buffer/ChannelBufferIndexFinder$5.class
    org/jboss/netty/util/internal/ConcurrentWeakKeyHashMap$KeyIterator.class
    org/jboss/netty/channel/AdaptiveReceiveBufferSizePredictorFactory.class
    org/jboss/netty/channel/group/ChannelGroupFuture.class
    org/jboss/netty/handler/codec/http/HttpChunkTrailer.class
    org/jboss/netty/util/internal/SharedResourceMisuseDetector.class
    org/jboss/netty/channel/socket/nio/SocketSendBufferPool$PreallocationRef.class
    org/jboss/netty/util/internal/ConcurrentWeakKeyHashMap$HashIterator.class
    org/jboss/netty/channel/socket/nio/NioDatagramWorker$ChannelRegistionTask.class
    org/jboss/netty/handler/codec/rtsp/RtspRequestEncoder.class
    org/jboss/netty/channel/socket/DatagramChannel.class
    org/jboss/netty/handler/codec/http/HttpServerCodec.class
    org/jboss/netty/channel/socket/oio/OioDatagramWorker.class
    org/jboss/netty/handler/codec/http/HttpMessageDecoder.class
    org/jboss/netty/handler/codec/embedder/EmbeddedChannel.class
    org/jboss/netty/util/internal/ConcurrentIdentityWeakKeyHashMap$WeakKeyReference.class
    org/jboss/netty/handler/codec/rtsp/RtspMessageDecoder.class
    org/jboss/netty/handler/ssl/SslHandler$ClosingChannelFutureListener.class
    org/jboss/netty/buffer/ChannelBufferIndexFinder$3.class
    org/jboss/netty/container/microcontainer/NettyLoggerConfigurator.class
    org/jboss/netty/channel/ChannelFuture.class
    org/jboss/netty/channel/socket/ServerSocketChannelFactory.class
    org/jboss/netty/channel/FailedChannelFuture.class
    org/jboss/netty/handler/codec/frame/FixedLengthFrameDecoder.class
    org/jboss/netty/handler/stream/ChunkedWriteHandler$2.class
    org/jboss/netty/channel/socket/SocketChannel.class
    org/jboss/netty/buffer/ChannelBufferIndexFinder$4.class
    org/jboss/netty/channel/FileRegion.class
    org/jboss/netty/handler/codec/http/HttpRequestEncoder.class
    org/jboss/netty/channel/socket/nio/NioAcceptedSocketChannel.class
    org/jboss/netty/util/CharsetUtil.class
    org/jboss/netty/buffer/SlicedChannelBuffer.class
    org/jboss/netty/handler/stream/ChunkedWriteHandler$1.class
    org/jboss/netty/handler/codec/http/DefaultHttpChunk.class
    org/jboss/netty/buffer/DynamicChannelBuffer.class
    org/jboss/netty/channel/socket/ServerSocketChannel.class
    org/jboss/netty/container/osgi/NettyBundleActivator.class
    org/jboss/netty/channel/local/LocalClientChannelFactory.class
    org/jboss/netty/channel/DownstreamChannelStateEvent.class
    org/jboss/netty/util/internal/ConcurrentIdentityHashMap$Values.class
    org/jboss/netty/util/internal/ConcurrentIdentityHashMap$KeyIterator.class
    org/jboss/netty/util/internal/ConcurrentIdentityWeakKeyHashMap$ValueIterator.class
    org/jboss/netty/buffer/AbstractChannelBufferFactory.class
    org/jboss/netty/channel/socket/nio/DefaultNioDatagramChannelConfig.class
    org/jboss/netty/channel/ChannelPipeline.class
    org/jboss/netty/channel/socket/nio/NioDatagramPipelineSink$1.class
    org/jboss/netty/util/VirtualExecutorService.class
    org/jboss/netty/handler/timeout/WriteTimeoutHandler$WriteTimeoutTask.class
    org/jboss/netty/channel/local/DefaultLocalServerChannel.class
    org/jboss/netty/util/internal/ConcurrentIdentityHashMap.class
    org/jboss/netty/channel/socket/http/HttpTunnelingClientSocketChannel$5$1.class
    org/jboss/netty/channel/FixedReceiveBufferSizePredictor.class
    org/jboss/netty/handler/stream/ChunkedWriteHandler.class
    org/jboss/netty/channel/socket/nio/SocketSendBufferPool$PooledSendBuffer.class
    org/jboss/netty/util/EstimatableObjectWrapper.class
    org/jboss/netty/channel/socket/nio/NioDatagramChannelConfig.class
    org/jboss/netty/channel/socket/nio/NioDatagramChannelFactory.class
    org/jboss/netty/handler/ssl/SslHandler$3.class
    org/jboss/netty/channel/group/CombinedIterator.class
    org/jboss/netty/channel/socket/http/HttpTunnelingClientSocketChannel$6.class
    org/jboss/netty/logging/OsgiLogger.class
    org/jboss/netty/channel/group/ChannelGroupFutureListener.class
    org/jboss/netty/channel/DefaultServerChannelConfig.class
    org/jboss/netty/handler/codec/http/HttpChunk$1.class
    org/jboss/netty/util/internal/ConcurrentHashMap$Segment.class
    org/jboss/netty/util/internal/ConcurrentIdentityHashMap$EntrySet.class
    org/jboss/netty/channel/ChannelFutureListener.class
    org/jboss/netty/handler/codec/compression/ZlibEncoder$1.class
    org/jboss/netty/handler/codec/replay/UnreplayableOperationException.class
    org/jboss/netty/handler/codec/serialization/CompactObjectOutputStream.class
    org/jboss/netty/handler/execution/MemoryAwareThreadPoolExecutor$NewThreadRunsPolicy.class
    org/jboss/netty/handler/codec/protobuf/ProtobufEncoder.class
    org/jboss/netty/channel/local/LocalChannelRegistry.class
    org/jboss/netty/handler/codec/string/StringDecoder.class
    org/jboss/netty/util/ExternalResourceUtil.class
    org/jboss/netty/handler/codec/http/QueryStringDecoder.class
    org/jboss/netty/channel/socket/oio/OioDatagramPipelineSink$1.class
    org/jboss/netty/channel/Channel.class
    org/jboss/netty/util/internal/ConcurrentIdentityHashMap$SimpleEntry.class
    org/jboss/netty/handler/timeout/IdleStateHandler.class
    org/jboss/netty/channel/ChannelEvent.class
    org/jboss/netty/channel/SimpleChannelDownstreamHandler.class
    org/jboss/netty/util/DebugUtil.class
    org/jboss/netty/channel/socket/oio/OioServerSocketPipelineSink$1.class
    org/jboss/netty/channel/socket/http/HttpTunnelingClientSocketChannel$1.class
    org/jboss/netty/channel/UpstreamMessageEvent.class
    org/jboss/netty/handler/codec/http/CookieDecoder.class
    org/jboss/netty/util/internal/ConcurrentHashMap$ValueIterator.class
    org/jboss/netty/util/internal/ConcurrentIdentityHashMap$HashIterator.class
    org/jboss/netty/channel/local/DefaultLocalClientChannelFactory.class
    org/jboss/netty/channel/socket/nio/SocketSendBufferPool.class
    org/jboss/netty/util/internal/ConcurrentIdentityWeakKeyHashMap.class
    org/jboss/netty/util/internal/ConcurrentHashMap.class
    org/jboss/netty/channel/local/LocalChannel.class
    org/jboss/netty/logging/InternalLoggerFactory.class
    org/jboss/netty/handler/codec/embedder/CodecEmbedder.class
    org/jboss/netty/handler/stream/ChunkedFile.class
    org/jboss/netty/handler/timeout/ReadTimeoutHandler.class
    org/jboss/netty/logging/Slf4JLoggerFactory.class
    org/jboss/netty/handler/execution/OrderedMemoryAwareThreadPoolExecutor.class
    org/jboss/netty/util/internal/ConcurrentWeakKeyHashMap$EntryIterator.class
    org/jboss/netty/buffer/ChannelBufferFactory.class
    org/jboss/netty/channel/FixedReceiveBufferSizePredictorFactory.class
    org/jboss/netty/buffer/ChannelBufferIndexFinder$8.class
    org/jboss/netty/handler/timeout/IdleStateHandler$ReaderIdleTimeoutTask.class
    org/jboss/netty/handler/codec/serialization/CompatibleObjectDecoder.class
    org/jboss/netty/util/internal/ConcurrentWeakKeyHashMap$HashEntry.class
    org/jboss/netty/logging/Log4JLogger.class
    org/jboss/netty/logging/JBossLoggerFactory.class
    org/jboss/netty/handler/timeout/IdleStateEvent.class
    org/jboss/netty/util/internal/ConcurrentIdentityWeakKeyHashMap$WriteThroughEntry.class
    org/jboss/netty/channel/local/LocalAddress.class
    org/jboss/netty/handler/codec/http/CookieHeaderNames.class
    org/jboss/netty/channel/socket/nio/SocketSendBufferPool$FileSendBuffer.class
    org/jboss/netty/channel/socket/nio/SelectorUtil.class
    org/jboss/netty/handler/codec/replay/ReplayingDecoder.class
    org/jboss/netty/handler/timeout/IdleState.class
    org/jboss/netty/channel/ChannelState.class
    org/jboss/netty/util/internal/ConcurrentIdentityWeakKeyHashMap$EntryIterator.class
    org/jboss/netty/handler/codec/http/HttpMessageDecoder$State.class
    org/jboss/netty/logging/JdkLogger.class
    org/jboss/netty/channel/group/DefaultChannelGroupFuture.class
    org/jboss/netty/channel/AbstractServerChannel.class
    org/jboss/netty/handler/codec/rtsp/RtspRequestDecoder.class
    org/jboss/netty/buffer/ChannelBufferIndexFinder$10.class
    org/jboss/netty/util/internal/SystemPropertyUtil.class
    org/jboss/netty/logging/AbstractInternalLogger.class
    org/jboss/netty/channel/SimpleChannelUpstreamHandler$1.class
    org/jboss/netty/handler/execution/MemoryAwareThreadPoolExecutor.class
    org/jboss/netty/channel/UpstreamChannelStateEvent.class
    org/jboss/netty/handler/codec/oneone/OneToOneDecoder.class
    org/jboss/netty/util/Timer.class
    org/jboss/netty/channel/socket/http/HttpTunnelingClientSocketChannel$2$1.class
    org/jboss/netty/container/spring/NettyLoggerConfigurator.class
    org/jboss/netty/handler/codec/http/CookieEncoder.class
    org/jboss/netty/channel/local/LocalClientChannelSink$1.class
    org/jboss/netty/handler/execution/ChannelEventRunnable.class
    org/jboss/netty/util/internal/StackTraceSimplifier.class
    org/jboss/netty/util/internal/jzlib/InfTree.class
    org/jboss/netty/util/Timeout.class
    org/jboss/netty/channel/socket/http/HttpTunnelingClientSocketChannel$ServletChannelHandler.class
    org/jboss/netty/logging/JBossLogger.class
    org/jboss/netty/util/internal/ConcurrentIdentityWeakKeyHashMap$KeySet.class
    org/jboss/netty/handler/codec/compression/CompressionException.class
    org/jboss/netty/util/ThreadRenamingRunnable.class
    org/jboss/netty/handler/stream/ChunkedStream.class
    org/jboss/netty/util/internal/ConcurrentIdentityHashMap$HashEntry.class
    org/jboss/netty/util/internal/AtomicFieldUpdaterUtil.class
    org/jboss/netty/handler/timeout/IdleStateAwareChannelUpstreamHandler.class
    org/jboss/netty/channel/socket/oio/OioServerSocketPipelineSink$Boss.class
    org/jboss/netty/buffer/ByteBufferBackedChannelBuffer.class
    org/jboss/netty/channel/DefaultChannelFuture.class
    org/jboss/netty/buffer/ChannelBufferInputStream.class
    org/jboss/netty/channel/socket/http/HttpTunnelingClientSocketChannel$4.class
    org/jboss/netty/handler/codec/embedder/CodecEmbedderException.class
    org/jboss/netty/logging/Slf4JLogger.class
    org/jboss/netty/channel/DownstreamChannelStateEvent$1.class
    org/jboss/netty/channel/socket/http/HttpTunnelingServlet$OutboundConnectionHandler.class
    org/jboss/netty/channel/socket/nio/NioServerSocketChannel.class
    org/jboss/netty/channel/socket/oio/OioServerSocketChannelFactory.class
    org/jboss/netty/util/internal/ReusableIterator.class
    org/jboss/netty/util/internal/jzlib/Adler32.class
    org/jboss/netty/handler/codec/embedder/AbstractCodecEmbedder$EmbeddedChannelSink.class
    org/jboss/netty/handler/codec/http/HttpClientCodec$Decoder.class
    org/jboss/netty/util/HashedWheelTimer$HashedWheelTimeout.class
    org/jboss/netty/handler/codec/rtsp/RtspHeaders.class
    org/jboss/netty/handler/codec/http/HttpResponseStatus.class
    org/jboss/netty/util/internal/ConcurrentHashMap$KeyIterator.class
    org/jboss/netty/buffer/TruncatedChannelBuffer.class
    org/jboss/netty/handler/codec/http/HttpHeaders$Names.class
    org/jboss/netty/channel/DefaultChildChannelStateEvent.class
    org/jboss/netty/handler/codec/rtsp/RtspHeaders$Names.class
    org/jboss/netty/handler/codec/frame/FrameDecoder.class
    org/jboss/netty/channel/group/DefaultChannelGroup$1.class
    org/jboss/netty/channel/CompleteChannelFuture.class
    org/jboss/netty/handler/codec/serialization/ObjectEncoder.class
    org/jboss/netty/handler/codec/frame/LengthFieldBasedFrameDecoder.class
    org/jboss/netty/handler/codec/embedder/DecoderEmbedder.class
    org/jboss/netty/handler/stream/ChunkedNioFile.class
    org/jboss/netty/handler/codec/http/DefaultHttpRequest.class
    org/jboss/netty/handler/codec/http/DefaultHttpMessage.class
    org/jboss/netty/util/internal/ConcurrentWeakKeyHashMap$ValueIterator.class
    org/jboss/netty/channel/ChannelUpstreamHandler.class
    org/jboss/netty/util/internal/jzlib/CRC32.class
    org/jboss/netty/handler/codec/http/HttpHeaders$Values.class
    org/jboss/netty/handler/timeout/TimeoutException.class
    org/jboss/netty/handler/execution/MemoryAwareThreadPoolExecutor$Settings.class
    org/jboss/netty/channel/group/ChannelGroup.class
    org/jboss/netty/handler/codec/embedder/AbstractCodecEmbedder.class
    org/jboss/netty/channel/socket/DatagramChannelConfig.class
    org/jboss/netty/channel/local/DefaultLocalChannel.class
    org/jboss/netty/channel/ChannelFutureListener$2.class
    org/jboss/netty/handler/codec/http/HttpMethod.class
    org/jboss/netty/channel/ChannelHandler$Sharable.class
    org/jboss/netty/handler/codec/base64/Base64.class
    org/jboss/netty/channel/local/LocalServerChannelSink$1.class
    org/jboss/netty/channel/socket/DefaultDatagramChannelConfig.class
    org/jboss/netty/channel/socket/nio/NioDatagramWorker.class
    org/jboss/netty/handler/ssl/SslHandler$1.class
    org/jboss/netty/handler/codec/http/HttpMessage.class
    org/jboss/netty/util/internal/ConcurrentIdentityWeakKeyHashMap$HashIterator.class
    org/jboss/netty/handler/codec/serialization/ObjectDecoderInputStream.class
    org/jboss/netty/handler/timeout/DefaultIdleStateEvent.class
    org/jboss/netty/channel/socket/nio/NioClientSocketChannelFactory.class
    org/jboss/netty/logging/OsgiLoggerFactory.class
    org/jboss/netty/handler/codec/http/HttpRequest.class
    org/jboss/netty/channel/socket/http/HttpTunnelingClientSocketChannel.class
    org/jboss/netty/handler/codec/http/HttpContentDecompressor.class
    org/jboss/netty/util/CharsetUtil$2.class
    org/jboss/netty/channel/AbstractChannel.class
    org/jboss/netty/handler/ssl/SslHandler.class
    org/jboss/netty/bootstrap/ConnectionlessBootstrap.class
    org/jboss/netty/channel/UpstreamChannelStateEvent$1.class
    org/jboss/netty/channel/socket/http/HttpTunnelingClientSocketChannel$6$1.class
    org/jboss/netty/channel/SucceededChannelFuture.class
    org/jboss/netty/channel/socket/nio/SocketSendBufferPool$UnpooledSendBuffer.class
    org/jboss/netty/handler/codec/protobuf/ProtobufDecoder.class
    org/jboss/netty/util/TimerTask.class
    org/jboss/netty/channel/SimpleChannelUpstreamHandler.class
    org/jboss/netty/handler/codec/rtsp/RtspMessageEncoder.class
    org/jboss/netty/util/internal/ConcurrentWeakKeyHashMap$WeakKeyReference.class
    org/jboss/netty/util/internal/NonReentrantLock.class
    org/jboss/netty/channel/socket/nio/NioWorker$RegisterTask.class
    org/jboss/netty/channel/socket/oio/OioAcceptedSocketChannel.class
    org/jboss/netty/util/ThreadNameDeterminer.class
    org/jboss/netty/buffer/WrappedChannelBuffer.class
    org/jboss/netty/channel/ChannelPipelineFactory.class
    org/jboss/netty/handler/codec/protobuf/ProtobufVarint32LengthFieldPrepender.class
    org/jboss/netty/util/internal/ConcurrentHashMap$HashEntry.class
    org/jboss/netty/handler/ssl/SslHandler$PendingWrite.class
    org/jboss/netty/util/internal/ConcurrentHashMap$EntryIterator.class
    org/jboss/netty/channel/ServerChannel.class
    org/jboss/netty/util/internal/ConcurrentIdentityWeakKeyHashMap$HashEntry.class
    org/jboss/netty/channel/ReceiveBufferSizePredictorFactory.class
    org/jboss/netty/channel/socket/oio/OioDatagramChannel.class
    org/jboss/netty/channel/ChannelStateEvent.class
    org/jboss/netty/util/internal/ConcurrentHashMap$WriteThroughEntry.class
    org/jboss/netty/channel/socket/nio/NioServerSocketPipelineSink.class
    org/jboss/netty/util/CharsetUtil$1.class
    org/jboss/netty/buffer/AbstractChannelBuffer.class
    org/jboss/netty/util/internal/jzlib/StaticTree.class
    org/jboss/netty/buffer/HeapChannelBuffer.class
    org/jboss/netty/util/internal/jzlib/InfBlocks.class
    org/jboss/netty/channel/DownstreamMessageEvent.class
    org/jboss/netty/handler/codec/replay/VoidEnum.class
    org/jboss/netty/channel/socket/oio/OioSocketChannel.class
    org/jboss/netty/handler/codec/frame/Delimiters.class
    org/jboss/netty/logging/InternalLogLevel.class
    org/jboss/netty/handler/codec/http/HttpChunk.class
    org/jboss/netty/channel/ServerChannelFactory.class
    org/jboss/netty/channel/ChannelFutureListener$1.class
    org/jboss/netty/handler/codec/frame/DelimiterBasedFrameDecoder.class
    org/jboss/netty/buffer/ChannelBuffers.class
    org/jboss/netty/channel/socket/http/HttpTunnelingClientSocketChannel$7$1.class
    org/jboss/netty/handler/codec/base64/Base64Encoder.class
    org/jboss/netty/handler/queue/BlockingReadHandler.class
    org/jboss/netty/bootstrap/ClientBootstrap.class
    org/jboss/netty/util/internal/ConcurrentWeakKeyHashMap$KeySet.class
    org/jboss/netty/handler/codec/serialization/CompactObjectInputStream.class
    org/jboss/netty/channel/Channels.class
    org/jboss/netty/channel/socket/oio/OioClientSocketPipelineSink.class
    org/jboss/netty/handler/codec/serialization/CompatibleObjectEncoder.class
    org/jboss/netty/util/HashedWheelTimer.class
    org/jboss/netty/bootstrap/Bootstrap.class
    org/jboss/netty/handler/codec/embedder/EmbeddedChannelFactory.class
    org/jboss/netty/util/internal/ConcurrentHashMap$SimpleEntry.class
    org/jboss/netty/handler/codec/http/QueryStringEncoder$Param.class
    org/jboss/netty/logging/JdkLoggerFactory.class
    org/jboss/netty/handler/codec/http/HttpResponseDecoder.class
    org/jboss/netty/channel/socket/DefaultServerSocketChannelConfig.class
    org/jboss/netty/channel/ChannelPipelineCoverage.class
    org/jboss/netty/channel/socket/nio/NioServerSocketChannelFactory.class
    org/jboss/netty/channel/ReceiveBufferSizePredictor.class
    org/jboss/netty/logging/OsgiLoggerFactory$1.class
    org/jboss/netty/util/internal/jzlib/JZlib$WrapperType.class
    org/jboss/netty/channel/socket/oio/OioDatagramChannelFactory.class
    org/jboss/netty/handler/codec/base64/Base64Dialect.class
    org/jboss/netty/channel/ChannelDownstreamHandler.class
    org/jboss/netty/channel/socket/http/HttpTunnelingServlet.class
    org/jboss/netty/util/ExternalResourceReleasable.class
    org/jboss/netty/handler/codec/embedder/EncoderEmbedder.class
    org/jboss/netty/handler/codec/rtsp/RtspVersions.class
    org/jboss/netty/util/internal/AtomicFieldUpdaterUtil$Node.class
    org/jboss/netty/channel/DefaultChannelConfig.class
    org/jboss/netty/channel/SimpleChannelHandler$1.class
    org/jboss/netty/channel/socket/http/HttpTunnelingSocketChannelConfig.class
    org/jboss/netty/handler/execution/OrderedMemoryAwareThreadPoolExecutor$ChildExecutor.class
    org/jboss/netty/channel/ChannelFutureProgressListener.class
    org/jboss/netty/channel/MessageEvent.class
    org/jboss/netty/channel/local/LocalServerChannelSink.class
    org/jboss/netty/handler/execution/ExecutionHandler.class
    org/jboss/netty/handler/codec/http/HttpMessageDecoder$1.class
    org/jboss/netty/channel/local/LocalClientChannelSink.class
    org/jboss/netty/channel/ExceptionEvent.class
    org/jboss/netty/util/DefaultObjectSizeEstimator.class
    org/jboss/netty/util/internal/ExecutorUtil.class
    org/jboss/netty/buffer/DirectChannelBufferFactory.class
    org/jboss/netty/channel/socket/SocketChannelConfig.class

  Found in:
    org.slf4j:slf4j-log4j12:jar:1.7.16:compile
    ch.qos.logback:logback-classic:jar:1.2.2:compile
  Duplicate classes:
    org/slf4j/impl/StaticMDCBinder.class
    org/slf4j/impl/StaticMarkerBinder.class
    org/slf4j/impl/StaticLoggerBinder.class

[INFO] 
[INFO] --- ossindex-maven-plugin:2.3.7:audit (default-audit) @ bad-child ---
[INFO] OSS Index dependency audit
[INFO] org.apache.struts:struts2-core:2.5.14.1 - 61 known vulnerabilities, 0 affecting installed version
[INFO] org.freemarker:freemarker:2.3.26-incubating - No known vulnerabilities
[INFO] ognl:ognl:3.1.15 - 1 known vulnerabilities, 0 affecting installed version
[INFO] org.javassist:javassist:3.20.0-GA - No known vulnerabilities
[INFO] org.apache.logging.log4j:log4j-api:2.9.1 - No known vulnerabilities
[INFO] commons-fileupload:commons-fileupload:1.3.3 - 5 known vulnerabilities, 0 affecting installed version
[INFO] org.apache.commons:commons-lang3:3.6 - No known vulnerabilities
[INFO] com.google.guava:guava:17.0 - No known vulnerabilities
[ERROR] 
[ERROR] --------------------------------------------------------------
[ERROR] org.jboss.netty:netty:3.2.2.Final  [VULNERABLE]
[ERROR] 4 known vulnerabilities, 1 affecting installed version
[ERROR] 
[ERROR] POODLE vulnerability in SSLv3.0 support
[ERROR] https://ossindex.net/resource/vulnerability/8402382265
[ERROR] The SSLv3 support is vulnerable to a POODLE attack. SSLv3 should be disabled pending implementation of TLS_FALLBACK_SCSV by Oracle.
[ERROR] 
[ERROR] --------------------------------------------------------------
[ERROR] 
[ERROR] 
[ERROR] --------------------------------------------------------------
[ERROR] io.netty:netty:3.7.0.Final  [VULNERABLE]
[ERROR] 4 known vulnerabilities, 3 affecting installed version
[ERROR] 
[ERROR] [CVE-2014-0193]  Resource Management Errors
[ERROR] https://ossindex.net/resource/cve/359831
[ERROR] WebSocket08FrameDecoder in Netty 3.6.x before 3.6.9, 3.7.x before 3.7.1, 3.8.x before 3.8.2, 3.9.x before 3.9.1, and 4.0.x before 4.0.19 allows remote attackers to cause a denial of service (memory consumption) via a TextWebSocketFrame followed by a long stream of ContinuationWebSocketFrames.
[ERROR] 
[ERROR] [CVE-2014-3488]  Improper Restriction of Operations within the Bounds of a Memory Buffer
[ERROR] https://ossindex.net/resource/cve/362374
[ERROR] The SslHandler in Netty before 3.9.2 allows remote attackers to cause a denial of service (infinite loop and CPU consumption) via a crafted SSLv2Hello message.
[ERROR] 
[ERROR] POODLE vulnerability in SSLv3.0 support
[ERROR] https://ossindex.net/resource/vulnerability/8402382265
[ERROR] The SSLv3 support is vulnerable to a POODLE attack. SSLv3 should be disabled pending implementation of TLS_FALLBACK_SCSV by Oracle.
[ERROR] 
[ERROR] --------------------------------------------------------------
[ERROR] 
[INFO] org.slf4j:slf4j-api:1.7.25 - No known vulnerabilities
[INFO] ch.qos.logback:logback-classic:1.2.2 - No known vulnerabilities
[INFO] ch.qos.logback:logback-core:1.2.2 - 1 known vulnerabilities, 0 affecting installed version
[INFO] org.slf4j:slf4j-log4j12:1.7.16 - No known vulnerabilities
[INFO] log4j:log4j:1.2.17 - No known vulnerabilities
[INFO] 
[INFO] --- maven-resources-plugin:2.6:resources (default-resources) @ bad-child ---
[INFO] Using 'gbk' encoding to copy filtered resources.
[INFO] Copying 0 resource
[INFO] 
[INFO] --- maven-compiler-plugin:3.1:compile (default-compile) @ bad-child ---
[INFO] Nothing to compile - all classes are up to date
[INFO]                                                                         
[INFO] ------------------------------------------------------------------------
[INFO] Building framework-bom 1.0.1
[INFO] ------------------------------------------------------------------------
[INFO] 
[INFO] --- maven-enforcer-plugin:3.0.0-M2:enforce (default-enforcer) @ framework-bom ---
[WARNING] Rule 2: org.apache.maven.plugins.enforcer.ReactorModuleConvergence failed with message:
The reactor contains different versions.
[WARNING][Enforcer] 多模块项目子模块需要保持版本号相同（建议不要显式设置子模块版本号，从parent继承）
 --> com.youzan.i.hujixu:bad-child:jar:1.0.2

[INFO] 
[INFO] --- maven-enforcer-plugin:3.0.0-M2:enforce (blacklist-struts-dependencies) @ framework-bom ---
[INFO] 
[INFO] --- maven-enforcer-plugin:3.0.0-M2:enforce (force-guava-versions) @ framework-bom ---
[INFO] 
[INFO] --- maven-enforcer-plugin:3.0.0-M2:enforce (duplicate-class) @ framework-bom ---
[INFO] Adding ignore: module-info
[INFO] Adding ignore: META-INF/versions/*/module-info
[INFO] Adding ignore: *.R
[INFO] Adding ignore: org.apache.commons.logging.*
[INFO] 
[INFO] --- ossindex-maven-plugin:2.3.7:audit (default-audit) @ framework-bom ---
[INFO] OSS Index dependency audit
[INFO]                                                                         
[INFO] ------------------------------------------------------------------------
[INFO] Building bom-demo 1.0.1
[INFO] ------------------------------------------------------------------------
[INFO] 
[INFO] --- maven-enforcer-plugin:3.0.0-M2:enforce (default-enforcer) @ bom-demo ---
[WARNING] 
Dependency convergence error for org.slf4j:slf4j-api:1.7.21 paths to dependency are:
+-com.youzan.i.hujixu:bom-demo:1.0.1
  +-com.youzan.platform:spring-nsq:1.0.4.1-RELEASE
    +-com.youzan:NSQ-Client:2.4.1.11-RELEASE
      +-org.slf4j:slf4j-api:1.7.21
and
+-com.youzan.i.hujixu:bom-demo:1.0.1
  +-com.youzan.platform:spring-nsq:1.0.4.1-RELEASE
    +-com.youzan:NSQ-Client:2.4.1.11-RELEASE
      +-org.slf4j:jul-to-slf4j:1.7.21
        +-org.slf4j:slf4j-api:1.7.21
and
+-com.youzan.i.hujixu:bom-demo:1.0.1
  +-com.youzan.platform:spring-nsq:1.0.4.1-RELEASE
    +-com.youzan:NSQ-Client:2.4.1.11-RELEASE
      +-org.slf4j:jcl-over-slf4j:1.7.21
        +-org.slf4j:slf4j-api:1.7.21
and
+-com.youzan.i.hujixu:bom-demo:1.0.1
  +-com.youzan.platform:spring-nsq:1.0.4.1-RELEASE
    +-com.youzan:NSQ-Client:2.4.1.11-RELEASE
      +-com.youzan:DCC-Client:1.1.0622-RELEASE
        +-org.slf4j:slf4j-api:1.7.6
and
+-com.youzan.i.hujixu:bom-demo:1.0.1
  +-com.youzan.platform:spring-nsq:1.0.4.1-RELEASE
    +-org.apache.curator:curator-framework:2.8.0
      +-org.apache.curator:curator-client:2.8.0
        +-org.slf4j:slf4j-api:1.7.6
and
+-com.youzan.i.hujixu:bom-demo:1.0.1
  +-com.youzan.platform:spring-nsq:1.0.4.1-RELEASE
    +-org.apache.curator:curator-framework:2.8.0
      +-org.apache.zookeeper:zookeeper:3.4.6
        +-org.slf4j:slf4j-api:1.6.1

[WARNING] 
Dependency convergence error for com.google.guava:guava:23.6-android paths to dependency are:
+-com.youzan.i.hujixu:bom-demo:1.0.1
  +-com.youzan.platform:spring-nsq:1.0.4.1-RELEASE
    +-com.youzan:NSQ-Client:2.4.1.11-RELEASE
      +-com.google.guava:guava:23.6-android
and
+-com.youzan.i.hujixu:bom-demo:1.0.1
  +-com.youzan.platform:spring-nsq:1.0.4.1-RELEASE
    +-org.apache.curator:curator-framework:2.8.0
      +-org.apache.curator:curator-client:2.8.0
        +-com.google.guava:guava:16.0.1
and
+-com.youzan.i.hujixu:bom-demo:1.0.1
  +-com.youzan.platform:spring-nsq:1.0.4.1-RELEASE
    +-org.apache.curator:curator-framework:2.8.0
      +-com.google.guava:guava:16.0.1
and
+-com.youzan.i.hujixu:bom-demo:1.0.1
  +-com.youzan.platform:spring-nsq:1.0.4.1-RELEASE
    +-org.apache.curator:curator-recipes:2.8.0
      +-com.google.guava:guava:16.0.1

[WARNING] 
Dependency convergence error for org.apache.httpcomponents:httpcore:4.4.4 paths to dependency are:
+-com.youzan.i.hujixu:bom-demo:1.0.1
  +-com.youzan.platform:spring-nsq:1.0.4.1-RELEASE
    +-com.youzan:NSQ-Client:2.4.1.11-RELEASE
      +-com.youzan:DCC-Client:1.1.0622-RELEASE
        +-org.apache.httpcomponents:httpclient:4.5.2
          +-org.apache.httpcomponents:httpcore:4.4.4
and
+-com.youzan.i.hujixu:bom-demo:1.0.1
  +-com.youzan.platform:spring-nsq:1.0.4.1-RELEASE
    +-com.youzan:NSQ-Client:2.4.1.11-RELEASE
      +-com.youzan:DCC-Client:1.1.0622-RELEASE
        +-org.apache.httpcomponents:httpcore:4.4.5
and
+-com.youzan.i.hujixu:bom-demo:1.0.1
  +-com.youzan.platform:spring-nsq:1.0.4.1-RELEASE
    +-com.youzan:NSQ-Client:2.4.1.11-RELEASE
      +-com.youzan:DCC-Client:1.1.0622-RELEASE
        +-org.apache.httpcomponents:httpcore-nio:4.4.5
          +-org.apache.httpcomponents:httpcore:4.4.5
and
+-com.youzan.i.hujixu:bom-demo:1.0.1
  +-com.youzan.platform:spring-nsq:1.0.4.1-RELEASE
    +-com.youzan:NSQ-Client:2.4.1.11-RELEASE
      +-com.youzan:DCC-Client:1.1.0622-RELEASE
        +-com.youzan:httpasyncclient:4.1.2-RELEASE
          +-org.apache.httpcomponents:httpcore:4.4.5

[WARNING] 
Dependency convergence error for org.slf4j:jul-to-slf4j:1.7.21 paths to dependency are:
+-com.youzan.i.hujixu:bom-demo:1.0.1
  +-com.youzan.platform:spring-nsq:1.0.4.1-RELEASE
    +-com.youzan:NSQ-Client:2.4.1.11-RELEASE
      +-org.slf4j:jul-to-slf4j:1.7.21
and
+-com.youzan.i.hujixu:bom-demo:1.0.1
  +-com.youzan.platform:spring-nsq:1.0.4.1-RELEASE
    +-com.youzan:NSQ-Client:2.4.1.11-RELEASE
      +-com.youzan:DCC-Client:1.1.0622-RELEASE
        +-org.slf4j:jul-to-slf4j:1.7.6

[WARNING] 
Dependency convergence error for commons-logging:commons-logging:1.2 paths to dependency are:
+-com.youzan.i.hujixu:bom-demo:1.0.1
  +-com.youzan.platform:spring-nsq:1.0.4.1-RELEASE
    +-com.youzan:NSQ-Client:2.4.1.11-RELEASE
      +-com.youzan:DCC-Client:1.1.0622-RELEASE
        +-org.apache.httpcomponents:httpclient:4.5.2
          +-commons-logging:commons-logging:1.2
and
+-com.youzan.i.hujixu:bom-demo:1.0.1
  +-com.youzan.platform:spring-nsq:1.0.4.1-RELEASE
    +-com.youzan:NSQ-Client:2.4.1.11-RELEASE
      +-com.youzan:DCC-Client:1.1.0622-RELEASE
        +-com.youzan:httpasyncclient:4.1.2-RELEASE
          +-commons-logging:commons-logging:1.2
and
+-com.youzan.i.hujixu:bom-demo:1.0.1
  +-com.youzan.platform:spring-nsq:1.0.4.1-RELEASE
    +-com.youzan:NSQ-Client:2.4.1.11-RELEASE
      +-com.youzan:DCC-Client:1.1.0622-RELEASE
        +-commons-validator:commons-validator:1.5.1
          +-commons-beanutils:commons-beanutils:1.9.2
            +-commons-logging:commons-logging:1.1.1
and
+-com.youzan.i.hujixu:bom-demo:1.0.1
  +-com.youzan.platform:spring-nsq:1.0.4.1-RELEASE
    +-com.youzan:NSQ-Client:2.4.1.11-RELEASE
      +-com.youzan:DCC-Client:1.1.0622-RELEASE
        +-commons-validator:commons-validator:1.5.1
          +-commons-logging:commons-logging:1.2

[WARNING] 
Dependency convergence error for com.fasterxml.jackson.core:jackson-databind:2.8.9 paths to dependency are:
+-com.youzan.i.hujixu:bom-demo:1.0.1
  +-com.youzan.platform:spring-nsq:1.0.4.1-RELEASE
    +-com.youzan:NSQ-Client:2.4.1.11-RELEASE
      +-com.fasterxml.jackson.core:jackson-databind:2.8.9
and
+-com.youzan.i.hujixu:bom-demo:1.0.1
  +-com.youzan.platform:spring-nsq:1.0.4.1-RELEASE
    +-com.youzan:NSQ-Client:2.4.1.11-RELEASE
      +-com.youzan:DCC-Client:1.1.0622-RELEASE
        +-com.fasterxml.jackson.core:jackson-databind:2.7.9.1

[WARNING] 
Dependency convergence error for org.slf4j:jcl-over-slf4j:1.7.21 paths to dependency are:
+-com.youzan.i.hujixu:bom-demo:1.0.1
  +-com.youzan.platform:spring-nsq:1.0.4.1-RELEASE
    +-com.youzan:NSQ-Client:2.4.1.11-RELEASE
      +-org.slf4j:jcl-over-slf4j:1.7.21
and
+-com.youzan.i.hujixu:bom-demo:1.0.1
  +-com.youzan.platform:spring-nsq:1.0.4.1-RELEASE
    +-com.youzan:NSQ-Client:2.4.1.11-RELEASE
      +-com.youzan:DCC-Client:1.1.0622-RELEASE
        +-org.slf4j:jcl-over-slf4j:1.7.6

[WARNING] 
Dependency convergence error for commons-collections:commons-collections:3.2.1 paths to dependency are:
+-com.youzan.i.hujixu:bom-demo:1.0.1
  +-com.youzan.platform:spring-nsq:1.0.4.1-RELEASE
    +-com.youzan:NSQ-Client:2.4.1.11-RELEASE
      +-com.youzan:DCC-Client:1.1.0622-RELEASE
        +-commons-validator:commons-validator:1.5.1
          +-commons-beanutils:commons-beanutils:1.9.2
            +-commons-collections:commons-collections:3.2.1
and
+-com.youzan.i.hujixu:bom-demo:1.0.1
  +-com.youzan.platform:spring-nsq:1.0.4.1-RELEASE
    +-com.youzan:NSQ-Client:2.4.1.11-RELEASE
      +-com.youzan:DCC-Client:1.1.0622-RELEASE
        +-commons-validator:commons-validator:1.5.1
          +-commons-collections:commons-collections:3.2.2

[WARNING] Rule 1: org.apache.maven.plugins.enforcer.DependencyConvergence failed with message:
Failed while enforcing releasability. See above detailed error message.
[WARNING] Rule 2: org.apache.maven.plugins.enforcer.ReactorModuleConvergence failed with message:
The reactor contains different versions.
[WARNING][Enforcer] 多模块项目子模块需要保持版本号相同（建议不要显式设置子模块版本号，从parent继承）
 --> com.youzan.i.hujixu:bad-child:jar:1.0.2

[INFO] 
[INFO] --- maven-enforcer-plugin:3.0.0-M2:enforce (blacklist-struts-dependencies) @ bom-demo ---
[INFO] 
[INFO] --- maven-enforcer-plugin:3.0.0-M2:enforce (force-guava-versions) @ bom-demo ---
[INFO] 
[INFO] --- maven-enforcer-plugin:3.0.0-M2:enforce (duplicate-class) @ bom-demo ---
[INFO] Adding ignore: module-info
[INFO] Adding ignore: META-INF/versions/*/module-info
[INFO] Adding ignore: *.R
[INFO] Adding ignore: org.apache.commons.logging.*
[INFO] 
[INFO] --- ossindex-maven-plugin:2.3.7:audit (default-audit) @ bom-demo ---
[INFO] OSS Index dependency audit
[INFO] com.youzan.framework:redis-zan:1.0.11-RELEASE - No known vulnerabilities
[INFO] redis.clients:jedis:2.9.0 - No known vulnerabilities
[INFO] org.apache.commons:commons-pool2:2.4.2 - No known vulnerabilities
[INFO] com.youzan.platform:spring-nsq:1.0.4.1-RELEASE - No known vulnerabilities
[INFO] com.youzan:NSQ-Client:2.4.1.11-RELEASE - No known vulnerabilities
[INFO] com.google.guava:guava:23.6-android - No known vulnerabilities
[INFO] com.google.code.findbugs:jsr305:1.3.9 - No known vulnerabilities
[INFO] org.checkerframework:checker-compat-qual:2.0.0 - No known vulnerabilities
[INFO] com.google.errorprone:error_prone_annotations:2.1.3 - No known vulnerabilities
[INFO] com.google.j2objc:j2objc-annotations:1.1 - No known vulnerabilities
[INFO] org.codehaus.mojo:animal-sniffer-annotations:1.14 - No known vulnerabilities
[INFO] org.slf4j:slf4j-api:1.7.21 - No known vulnerabilities
[INFO] org.slf4j:jul-to-slf4j:1.7.21 - No known vulnerabilities
[INFO] org.slf4j:jcl-over-slf4j:1.7.21 - No known vulnerabilities
[INFO] io.netty:netty-all:4.1.13.Final - 4 known vulnerabilities, 0 affecting installed version
[INFO] org.apache.commons:commons-compress:1.14 - 1 known vulnerabilities, 0 affecting installed version
[INFO] com.fasterxml.jackson.core:jackson-databind:2.8.9 - No known vulnerabilities
[INFO] com.fasterxml.jackson.core:jackson-annotations:2.8.0 - No known vulnerabilities
[INFO] com.fasterxml.jackson.core:jackson-core:2.8.9 - No known vulnerabilities
[INFO] org.apache.commons:commons-lang3:3.6 - No known vulnerabilities
[INFO] com.youzan:DCC-Client:1.1.0622-RELEASE - No known vulnerabilities
[INFO] org.apache.httpcomponents:httpclient:4.5.2 - 5 known vulnerabilities, 0 affecting installed version
[INFO] commons-logging:commons-logging:1.2 - No known vulnerabilities
[INFO] commons-codec:commons-codec:1.9 - No known vulnerabilities
[INFO] org.apache.httpcomponents:httpcore:4.4.5 - No known vulnerabilities
[INFO] org.apache.httpcomponents:httpcore-nio:4.4.5 - No known vulnerabilities
[INFO] com.youzan:httpasyncclient:4.1.2-RELEASE - No known vulnerabilities
[INFO] org.javassist:javassist:3.20.0-GA - No known vulnerabilities
[INFO] commons-validator:commons-validator:1.5.1 - No known vulnerabilities
[ERROR] 
[ERROR] --------------------------------------------------------------
[ERROR] commons-beanutils:commons-beanutils:1.9.2  [VULNERABLE]
[ERROR]   required by com.youzan.platform:spring-nsq:1.0.4.1-RELEASE
[ERROR] 1 known vulnerabilities, 1 affecting installed version
[ERROR] 
[ERROR] [CVE-2014-0114]  Improper Input Validation
[ERROR] https://ossindex.net/resource/cve/359770
[ERROR] Apache Commons BeanUtils, as distributed in lib/commons-beanutils-1.8.0.jar in Apache Struts 1.x through 1.3.10 and in other products requiring commons-beanutils through 1.9.2, does not suppress the class property, which allows remote attackers to "manipulate" the ClassLoader and execute arbitrary code via the class parameter, as demonstrated by the passing of this parameter to the getClass method of the ActionForm object in Struts 1.
[ERROR] 
[ERROR] --------------------------------------------------------------
[ERROR] 
[INFO] commons-digester:commons-digester:1.8.1 - No known vulnerabilities
[INFO] commons-collections:commons-collections:3.2.2 - 2 known vulnerabilities, 0 affecting installed version
[INFO] org.apache.curator:curator-framework:2.8.0 - No known vulnerabilities
[INFO] org.apache.curator:curator-client:2.8.0 - No known vulnerabilities
[INFO] org.apache.zookeeper:zookeeper:3.4.6 - 2 known vulnerabilities, 0 affecting installed version
[INFO] log4j:log4j:1.2.16 - No known vulnerabilities
[ERROR] 
[ERROR] --------------------------------------------------------------
[ERROR] jline:jline:0.9.94  [VULNERABLE]
[ERROR]   required by com.youzan.platform:spring-nsq:1.0.4.1-RELEASE
[ERROR] 1 known vulnerabilities, 1 affecting installed version
[ERROR] 
[ERROR] [Dependency] Arbitrary code execution
[ERROR] https://ossindex.net/resource/vulnerability/8402731126
[ERROR] Due to a race condition in HawtJNI the JLine package is vulnerable to an arbitrary code execution vulnerability -- [CVE-2013-2035](https://ossindex.net/resource/cve/355726)
[ERROR] 
[ERROR] --------------------------------------------------------------
[ERROR] 
[ERROR] 
[ERROR] --------------------------------------------------------------
[ERROR] io.netty:netty:3.7.0.Final  [VULNERABLE]
[ERROR]   required by com.youzan.platform:spring-nsq:1.0.4.1-RELEASE
[ERROR] 4 known vulnerabilities, 3 affecting installed version
[ERROR] 
[ERROR] [CVE-2014-0193]  Resource Management Errors
[ERROR] https://ossindex.net/resource/cve/359831
[ERROR] WebSocket08FrameDecoder in Netty 3.6.x before 3.6.9, 3.7.x before 3.7.1, 3.8.x before 3.8.2, 3.9.x before 3.9.1, and 4.0.x before 4.0.19 allows remote attackers to cause a denial of service (memory consumption) via a TextWebSocketFrame followed by a long stream of ContinuationWebSocketFrames.
[ERROR] 
[ERROR] [CVE-2014-3488]  Improper Restriction of Operations within the Bounds of a Memory Buffer
[ERROR] https://ossindex.net/resource/cve/362374
[ERROR] The SslHandler in Netty before 3.9.2 allows remote attackers to cause a denial of service (infinite loop and CPU consumption) via a crafted SSLv2Hello message.
[ERROR] 
[ERROR] POODLE vulnerability in SSLv3.0 support
[ERROR] https://ossindex.net/resource/vulnerability/8402382265
[ERROR] The SSLv3 support is vulnerable to a POODLE attack. SSLv3 should be disabled pending implementation of TLS_FALLBACK_SCSV by Oracle.
[ERROR] 
[ERROR] --------------------------------------------------------------
[ERROR] 
[INFO] org.apache.curator:curator-recipes:2.8.0 - No known vulnerabilities
[INFO] 
[INFO] --- maven-resources-plugin:2.6:resources (default-resources) @ bom-demo ---
[INFO] Using 'utf-8' encoding to copy filtered resources.
[INFO] Copying 0 resource
[INFO] 
[INFO] --- maven-compiler-plugin:3.1:compile (default-compile) @ bom-demo ---
[INFO] Nothing to compile - all classes are up to date
[INFO] ------------------------------------------------------------------------
[INFO] Reactor Summary:
[INFO] 
[INFO] multi-module-demo .................................. SUCCESS [  5.180 s]
[INFO] bad-child .......................................... SUCCESS [  5.967 s]
[INFO] framework-bom ...................................... SUCCESS [  2.736 s]
[INFO] bom-demo ........................................... SUCCESS [  6.125 s]
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time: 20.211 s
[INFO] Finished at: 2018-07-04T09:57:34+08:00
[INFO] Final Memory: 20M/212M
[INFO] ------------------------------------------------------------------------

```
