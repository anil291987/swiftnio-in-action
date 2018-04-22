import NIO

// Listing 2.4 Main class for the client

public class EchoClient {
    private let port: UInt16
    private let host: String
    
    let echoClientHandler = EchoClientHandler()
    let eventLoopGroup = MultiThreadedEventLoopGroup(numThreads: 1)
    
    init(_ host: String, _ port: UInt16) {
        self.host = host
        self.port = port
    }
    
    deinit {
        try! eventLoopGroup.syncShutdownGracefully()
    }
    
    public func start() throws -> Channel {
        let clientBootstrap = ClientBootstrap(group: eventLoopGroup)
        let clientChannel = try clientBootstrap.channelInitializer { (channel) -> EventLoopFuture<Void> in
            channel.pipeline.add(handler: BackPressureHandler()).then { () in
                channel.pipeline.add(handler: self.echoClientHandler)
            }
            }.connect(host: host, port: Int(port)).wait()
        print("Client started")
        return clientChannel
    }
}
