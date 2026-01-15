//
//  BookPlant.swift
//  BookGarden
//
//  SwiftData 모델: 책 + 식물 상태
//

import Foundation
import SwiftData

// MARK: - Plant Status

enum PlantStatus: String, Codable {
    case growing = "growing"
    case harvested = "harvested"
}

// MARK: - Growth Stage

enum GrowthStage: String, CaseIterable {
    case empty      // 0%
    case seed       // 1-20%
    case sprout     // 21-40%
    case growing    // 41-60%
    case flowering  // 61-80%
    case mature     // 81-100%

    var symbolName: String {
        switch self {
        case .empty: return "leaf"
        case .seed: return "leaf.fill"
        case .sprout: return "leaf.arrow.triangle.circlepath"
        case .growing: return "tree"
        case .flowering: return "camera.macro"
        case .mature: return "tree.fill"
        }
    }

    var displayName: String {
        switch self {
        case .empty: return "빈 화분"
        case .seed: return "씨앗"
        case .sprout: return "새싹"
        case .growing: return "성장 중"
        case .flowering: return "꽃봉오리"
        case .mature: return "만개"
        }
    }

    static func from(progress: Double) -> GrowthStage {
        switch progress {
        case ..<0.2:
            return .seed       // 0% ~ 20% 미만: 씨앗
        case 0.2..<0.4:
            return .sprout     // 20% ~ 40%: 새싹
        case 0.4..<0.6:
            return .growing    // 40% ~ 60%: 성장 중
        case 0.6..<0.8:
            return .flowering  // 60% ~ 80%: 꽃봉오리
        default:
            return .mature     // 80% ~ 100%: 만개
        }
    }
}

// MARK: - BookPlant Model

@Model
final class BookPlant {
    var id: UUID
    var title: String
    var author: String
    var coverUrl: String?
    var totalPage: Int
    var currentPage: Int
    var statusRaw: String
    var plantedDate: Date
    var harvestedDate: Date?

    init(
        id: UUID = UUID(),
        title: String,
        author: String = "",
        coverUrl: String? = nil,
        totalPage: Int,
        currentPage: Int = 0,
        status: PlantStatus = .growing,
        plantedDate: Date = Date(),
        harvestedDate: Date? = nil
    ) {
        self.id = id
        self.title = title
        self.author = author
        self.coverUrl = coverUrl
        self.totalPage = totalPage
        self.currentPage = currentPage
        self.statusRaw = status.rawValue
        self.plantedDate = plantedDate
        self.harvestedDate = harvestedDate
    }

    // MARK: - Computed Properties

    var status: PlantStatus {
        get { PlantStatus(rawValue: statusRaw) ?? .growing }
        set { statusRaw = newValue.rawValue }
    }

    var progress: Double {
        guard totalPage > 0 else { return 0 }
        return min(Double(currentPage) / Double(totalPage), 1.0)
    }

    var progressPercent: Int {
        Int(progress * 100)
    }

    var growthStage: GrowthStage {
        GrowthStage.from(progress: progress)
    }

    var isCompleted: Bool {
        currentPage >= totalPage
    }

    var pagesRemaining: Int {
        max(totalPage - currentPage, 0)
    }

    // MARK: - Methods

    func updateProgress(to page: Int) {
        currentPage = min(max(page, 0), totalPage)

        if isCompleted && status == .growing {
            harvest()
        }
    }

    func harvest() {
        status = .harvested
        harvestedDate = Date()
        currentPage = totalPage
    }
}
