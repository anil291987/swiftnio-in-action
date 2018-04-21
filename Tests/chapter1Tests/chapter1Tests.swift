import XCTest
import NIO
@testable import chapter1

final class chapter1Tests: XCTestCase {
    class ReadHandler: ChannelInboundHandler {
        typealias InboundIn = ByteBuffer
        
        let message: String
        
        init(message: String) {
            self.message = message
        }
        
        func channelRead(ctx: ChannelHandlerContext, data: NIOAny) {
            var byteBuf = self.unwrapInboundIn(data)
            XCTAssertEqual(byteBuf.readString(length: byteBuf.readableBytes), message)
        }
    }
    
    func testConnectExampleWithHandler() throws {
        let lifeCycleExpectation = expectation(description: "life cycle is complete")
        let group = MultiThreadedEventLoopGroup(numThreads: 1)
        let message = "Hello, World!"
        let host = "127.0.0.1"
        let port: uint16 = 8080
        
        defer {
            try! group.syncShutdownGracefully()
        }
        
        let serverBootstrap = ServerBootstrap(group: group)
        let serverChannel = try serverBootstrap.childChannelInitializer({ channel  in
            channel.pipeline.add(handler: ConnectHandler()).then { v in
                channel.pipeline.add(handler: ReadHandler(message: message))
            }
            
        }).bind(host: host, port: Int(port)).wait()
        
        let connectExample = ConnectExample()
        let clientChannel = try connectExample.connect(ipAddress: host, port: port, message: message).wait()
        
        clientChannel.close(promise: nil)
        serverChannel.close(promise: nil)
        
        clientChannel.closeFuture.and(serverChannel.closeFuture).whenComplete {
            lifeCycleExpectation.fulfill()
        }
        wait(for: [lifeCycleExpectation], timeout: 1)
    }
    
    
    static var allTests = [
        ("testConnectExampleWithHanlder", testConnectExampleWithHandler),
        ]
}

