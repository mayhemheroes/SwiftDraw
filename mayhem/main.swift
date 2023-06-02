#if canImport(Darwin)
import Darwin.C
#elseif canImport(Glibc)
import Glibc
#elseif canImport(MSVCRT)
import MSVCRT
#endif

import Foundation
import SwiftDraw

let svg_options = [SVG.Options.ArrayLiteralElement(), SVG.Options.Element(), SVG.Options.default]

@_cdecl("LLVMFuzzerTestOneInput")
public func test(_ start: UnsafeRawPointer, _ count: Int) -> CInt {
    let fdp = FuzzedDataProvider(start, count)

    let data_choice = fdp.ConsumeIntegralInRange(from: 0, to: 3)

    let svg_str = fdp.ConsumeRandomLengthString()

    do {
        if data_choice == 0 {
            try SVGRenderer.makeExpanded(
                    path: fdp.ConsumeRandomLengthString(),
                    transform: fdp.ConsumeRandomLengthString(),
                    precision: fdp.ConsumeIntegralInRange(from: 0, to: 99))
        }
        else if let svg = SVG(data: Data(svg_str.utf8), options: fdp.PickValueInList(from: svg_options)) {
            switch (data_choice) {
            case 1:
                svg.pngData()
            case 2:
                svg.jpegData()
            case 3:
                svg.pdfData()
            default:
                fatalError("Unsupported data choice")
            }
        }
        return 0;
    }
    catch let err {
        if err.localizedDescription.contains("operation could not be completed") {
            return -1;
        }
        print(err.localizedDescription)
        print(type(of: err))
        exit(EXIT_FAILURE)
    }
}
