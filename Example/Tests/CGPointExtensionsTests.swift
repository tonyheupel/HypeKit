// https://github.com/Quick/Quick

import Quick
import Nimble
import HypeKit

class CGPointExtensionsSpecs: QuickSpec {
    override func spec() {
        describe("CGPoint distance to") {

            context("for positive points") {
                it("handles positive integers") {
                    let point1 = CGPoint(x: 0, y: 0)
                    let point2 = CGPoint(x: 3, y: 4)
                    let distance = point1.distance(to: point2)
                    let expected: CGFloat = 5
                    expect(distance) == expected
                }

                it("handles positives") {
                    let point1 = CGPoint(x: 12.73, y: 18.925)
                    let point2 = CGPoint(x: 92.9, y: 2015.52)
                    let distance = point1.distance(to: point2)
                    let expected: CGFloat = 1998.2038
                    expect(distance).to(beCloseTo(expected))
                }

            }

            context("for negative points") {
                it("handles negative integers") {
                    let point1 = CGPoint(x: -1, y: -1)
                    let point2 = CGPoint(x: -4, y: -5)
                    let distance = point1.distance(to: point2)
                    let expected: CGFloat = 5
                    expect(distance) == expected
                }

                it("handles negatives") {
                    let point1 = CGPoint(x: -12.73, y: -18.925)
                    let point2 = CGPoint(x: -92.9, y: -2015.52)
                    let distance = point1.distance(to: point2)
                    let expected: CGFloat = 1998.2038
                    expect(distance).to(beCloseTo(expected))
                }

            }

            // TODO: Add context for mixed numbers signs (pos/neg)
        }
    }
}
