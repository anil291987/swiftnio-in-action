import NIO

// Listing 2.2 EchoServer class

public class EchoServer {
    private let port: UInt16
    private let host: String
    
    let echoServerHandler = EchoServerHandler()
    let eventLoopGroup = MultiThreadedEventLoopGroup(numThreads: System.coreCount)
    
    init(_ host: String, _ port: UInt16) {
        self.host = host
        self.port = port
    }
    
    deinit {
        try! eventLoopGroup.syncShutdownGracefully()
    }
    
    public func start() throws -> Channel {
        let serverBootstrap = ServerBootstrap(group: eventLoopGroup)
        let serverChannel = try serverBootstrap.childChannelInitializer { (channel) -> EventLoopFuture<Void> in
            channel.pipeline.add(handler: BackPressureHandler()).then { () in
                channel.pipeline.add(handler: self.echoServerHandler)
            }
        }.bind(host: host, port: Int(port)).wait()
        print("Server started and listening on \(serverChannel.localAddress!)")
        return serverChannel
    }
}
