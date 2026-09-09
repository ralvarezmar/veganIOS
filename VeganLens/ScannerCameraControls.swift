import CoreGraphics

func clampedZoomFactor(
    _ desired: CGFloat,
    deviceMin: CGFloat,
    deviceMax: CGFloat
) -> CGFloat {
    min(max(desired, deviceMin), max(deviceMin, deviceMax))
}

func usableMaxZoomFactor(_ deviceMax: CGFloat) -> CGFloat {
    min(deviceMax, 5)
}
