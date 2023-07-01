/**
*  SwiftUIMasonry
*  Copyright (c) Ciaran O'Brien 2022
*  MIT license, see LICENSE file for details
*/

import SwiftUI

internal extension EnvironmentValues {
    var masonryPlacementMode: WaterfallPlacementMode {
        get { self[MasonryPlacementModeKey.self] }
        set { self[MasonryPlacementModeKey.self] = newValue }
    }
}


private struct MasonryPlacementModeKey: EnvironmentKey {
    static let defaultValue = WaterfallPlacementMode.fill
}
