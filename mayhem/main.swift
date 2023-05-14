#if canImport(Darwin)
import Darwin.C
#elseif canImport(Glibc)
import Glibc
#elseif canImport(MSVCRT)
import MSVCRT
#endif

import Foundation
import SwiftDraw

let supported_options = [
    SVG.Options.
]
@_cdecl("LLVMFuzzerTestOneInput")
public func test(_ start: UnsafeRawPointer, _ count: Int) -> CInt {
    let fdp = FuzzedDataProvider(start, count)
    let svg_data = Data(fdp.ConsumeRemainingString().utf8)
    SVG(data: svg_data, options: .Element)
    return 0;
}