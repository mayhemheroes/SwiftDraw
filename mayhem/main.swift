#if canImport(Darwin)
import Darwin.C
#elseif canImport(Glibc)
import Glibc
#elseif canImport(MSVCRT)
import MSVCRT
#endif

import Foundation
import SwiftDraw

@_cdecl("LLVMFuzzerTestOneInput")
public func test(_ start: UnsafeRawPointer, _ count: Int) -> CInt {
    let fdp = FuzzedDataProvider(start, count)
    let svg_data = Data(fdp.ConsumeRemainingString().utf8)
    
    let data_choice = fdp.ConsumeIntegralInRange(from: 0, to: 2)
    
    do {
        if let svg = SVG(data: svg_data) {
            switch (data_choice) {
            case 0:
                try svg.pngData()
            case 1:
                try svg.jpegData()
            case 2:
                try svg.pdfData()
            default:
                fatalError("Unsupported data choice")
            }
        }
        return 0;
    }
    catch let err {
//        print(err)
//        print(type(of: err))
        exit(EXIT_FAILURE)
    }
    return 0;
}
