import XCTest
import NIO
@testable import chapter4

final class chapter4Tests: XCTestCase {
    func testChannelOperationExamples() throws {
        class CoundHandler: ChannelInboundHandler {
            public typealias InboundIn = ByteBuffer
            private var count = 2
            func channelRead(ctx: ChannelHandlerContext, data: NIOAny) {
                var buffer = self.unwrapInboundIn(data)
                let string = buffer.readString(length: buffer.readableBytes)
                XCTAssertEqual(string, "some messagesome message")
            }
        }
        
        let group = MultiThreadedEventLoopGroup(numThreads: System.coreCount)
        defer {
            try! group.syncShutdownGracefully()
        }
        
        let serverBootstrap = ServerBootstrap(group: group)
        let serverChannel = try serverBootstrap
            .serverChannelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)
            .childChannelInitializer { (channel) -> EventLoopFuture<Void> in
                channel.pipeline.add(handler: CoundHandler())
        }.bind(host: "127.0.0.1", port: 8080).wait()
        
        let clientBootstrap = ClientBootstrap(group: group)
        let clientChannel = try clientBootstrap.connect(host: "127.0.0.1", port: 8080).wait()
        
        let channelOpExamples = ChannelOperationExamples(clientChannel)
        channelOpExamples.writingToChannelFromManyThreads()
        clientChannel.flush()
        try clientChannel.close().wait()
        try serverChannel.close().wait()
    }
    
    func testSwiftNIOServer() throws {
        class ClientHandlerTester: ChannelInboundHandler {
            public typealias InboundIn = ByteBuffer
            
            func channelRead(ctx: ChannelHandlerContext, data: NIOAny) {
                var byteBuffer = self.unwrapInboundIn(data)
                let message = byteBuffer.readString(length: byteBuffer.readableBytes)
                XCTAssertEqual(message, "Hi!\r\n")
                ctx.close(promise: nil)
            }
        }
        let group = MultiThreadedEventLoopGroup(numThreads: 1)
        defer {
            try! group.syncShutdownGracefully()
        }
        let swiftNIOServerChannel = try SwiftNIOServer.server(8080)
        
        let clientBootstrap = ClientBootstrap(group: group).channelInitializer { (channel) -> EventLoopFuture<Void> in
            channel.pipeline.add(handler: ClientHandlerTester())
        }
        let clientChannel1 = try clientBootstrap.connect(host: "127.0.0.1", port: 8080).wait()
        let clientChannel2 = try clientBootstrap.connect(host: "127.0.0.1", port: 8080).wait()
        
        try clientChannel1.closeFuture.wait()
        try clientChannel2.closeFuture.wait()
        swiftNIOServerChannel.close(promise: nil)
        try swiftNIOServerChannel.closeFuture.wait()
    }
    
    
    static var allTests = [
        ("testChannelOperationExamples", testChannelOperationExamples),
        ("testSwiftNIOServer", testSwiftNIOServer)
        ]
}



