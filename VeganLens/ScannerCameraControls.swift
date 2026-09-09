import CoreGraphics

func clampedZoomFactor(
    _ desired: CGFloat,
    deviceMin: CGFloat,
    deviceMax: CGFloat
) -> CGFloat {
    desired.clamped(to: deviceMin...deviceMax)
}

func usableMaxZoomFactor(_ deviceMax: CGFloat) -> CGFloat {
    min(deviceMax, 5)
}

private extension CGFloat {
    func clamped(to range: ClosedRange<CGFloat>) -> CGFloat {
        min(max(self, range.lowerBound), range.upperBound)
    }
}
