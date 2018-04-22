import XCTest
import NIO
@testable import chapter2

final class chapter2Tests: XCTestCase {
    func testEchoServerClient() throws {
        let echoServer = EchoServer("127.0.0.1", 8080)
        let echoClient = EchoClient("127.0.0.1", 8080)
        
        let serverChannel = try echoServer.start()
        let clientChannel = try echoClient.start()
        
        let _ = clientChannel.closeFuture.then {
            serverChannel.close()
        }
        
        let _ = try clientChannel.closeFuture.and(serverChannel.closeFuture).wait()
    }
    
    
    static var allTests = [
        ("testEchoServerClient", testEchoServerClient),
        ]
}


