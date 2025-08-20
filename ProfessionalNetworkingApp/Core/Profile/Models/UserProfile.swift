//
//  UserProfile.swift
//  ProfessionalNetworkingApp
//
//  Created by Junaed Chowdhury on 19/8/25.
//


import Foundation

struct UserProfile: Identifiable, Codable, Equatable {
    var id: String = UUID().uuidString

    // MARK: - Core Identity
    var fullName: String = ""
    var headline: String = ""         // e.g., "iOS Developer @ Beyond ITL"
    var bio: String = ""              // Short professional summary
    var avatarURL: URL? = nil
    var isVerified: Bool = false      // Profile authenticity badge

    // MARK: - Location
    var city: String? = nil
    var country: String? = nil

    // MARK: - Career
    var currentPosition: String? = nil    // e.g., "Software Engineer"
    var company: String? = nil            // e.g., "Beyond ITL"
    var industry: String? = nil           // e.g., "Information Technology"
    var experienceYears: Int? = nil       // Total professional experience

    // MARK: - Education
    var education: [Education] = []

    // MARK: - Professional Skills
    var skills: [String] = []             // e.g., ["Swift", "UI/UX", "Project Management"]
    var interests: [String] = []          // Broader interests (e.g., "AI", "Startups")

    // MARK: - Networking Intent
    var openTo: [NetworkingIntent] = []   // e.g., [".collaboration", ".mentorship"]

    // MARK: - Social / Connections
    var connections: [Connection] = []
}

// MARK: - Supporting Models

struct Education: Identifiable, Codable, Equatable {
    var id: String = UUID().uuidString
    var institution: String
    var degree: String?
    var fieldOfStudy: String?
    var startYear: Int?
    var endYear: Int?
}

struct Connection: Identifiable, Codable, Equatable {
    var id: String = UUID().uuidString
    var name: String
    var headline: String
    var avatarURL: URL?
}

/// Defines what a user is open to in a professional setting.
enum NetworkingIntent: String, Codable, CaseIterable {
    case collaboration
    case mentorship
    case hiring
    case jobSeeking
    case investment
}

// MARK: - Mock Data

struct MockProfiles {
    static let sample: [UserProfile] = [
        UserProfile(
            fullName: "Sophia Martinez",
            headline: "iOS Developer @ Beyond ITL",
            bio: "Passionate about building elegant mobile apps with Swift and SwiftUI. Advocate for clean architecture and mentoring junior devs.",
            avatarURL: URL(string: "https://i.pravatar.cc/500?img=12"),
            isVerified: true,
            city: "Kuala Lumpur",
            country: "Malaysia",
            currentPosition: "iOS Developer",
            company: "Beyond ITL",
            industry: "Information Technology",
            experienceYears: 4,
            education: [
                Education(institution: "UTM", degree: "MSc Software Engineering", fieldOfStudy: "Mobile Development", startYear: 2022, endYear: 2024)
            ],
            skills: ["Swift", "SwiftUI", "Combine", "MVVM", "Clean Architecture"],
            interests: ["AI", "Mobile UX", "Startups"],
            openTo: [.collaboration, .mentorship],
            connections: []
        ),
        UserProfile(
            fullName: "Daniel Wong",
            headline: "Cloud Architect | AWS Community Builder",
            bio: "Helping companies scale securely on AWS. Loves teaching serverless design and devops best practices.",
            avatarURL: URL(string: "https://i.pravatar.cc/500?img=4"),
            isVerified: true,
            city: "Singapore",
            country: "Singapore",
            currentPosition: "Cloud Solutions Architect",
            company: "Amazon Web Services",
            industry: "Cloud Computing",
            experienceYears: 8,
            education: [
                Education(institution: "NUS", degree: "BSc Computer Science", fieldOfStudy: "Distributed Systems", startYear: 2010, endYear: 2014)
            ],
            skills: ["AWS", "Kubernetes", "Terraform", "DevOps"],
            interests: ["Serverless", "Open Source", "Tech Communities"],
            openTo: [.mentorship, .hiring],
            connections: []
        ),
        UserProfile(
            fullName: "Aisha Khan",
            headline: "Product Designer @ Grab",
            bio: "Designing for millions of users across Southeast Asia. Focused on accessibility and human-centered design.",
            avatarURL: URL(string: "https://i.pravatar.cc/500?img=68"),
            city: "Jakarta",
            country: "Indonesia",
            currentPosition: "Senior Product Designer",
            company: "Grab",
            industry: "Consumer Tech",
            experienceYears: 6,
            education: [
                Education(institution: "Binus University", degree: "BA Design", fieldOfStudy: "Human-Centered Interaction", startYear: 2012, endYear: 2016)
            ],
            skills: ["Figma", "UX Research", "Accessibility", "Prototyping"],
            interests: ["UI Trends", "Design Systems"],
            openTo: [.collaboration],
            connections: []
        ),
        UserProfile(
            fullName: "Rajesh Patel",
            headline: "Full-Stack Engineer @ FinTech Startup",
            bio: "Enjoy building scalable financial apps. Loves TypeScript, Swift, and React Native.",
            avatarURL: URL(string: "https://i.pravatar.cc/500?img=21"),
            city: "Mumbai",
            country: "India",
            currentPosition: "Full-Stack Engineer",
            company: "PayWave",
            industry: "FinTech",
            experienceYears: 5,
            education: [
                Education(institution: "IIT Bombay", degree: "B.Tech", fieldOfStudy: "Computer Engineering", startYear: 2011, endYear: 2015)
            ],
            skills: ["Swift", "TypeScript", "Node.js", "React Native"],
            interests: ["Blockchain", "DeFi", "APIs"],
            openTo: [.collaboration, .jobSeeking],
            connections: []
        ),
        UserProfile(
            fullName: "Emily Carter",
            headline: "AI Research Scientist | PhD",
            bio: "Working on NLP and ethical AI. Published in top-tier journals. Excited about open-source research.",
            avatarURL: URL(string: "https://i.pravatar.cc/500?img=33"),
            city: "Toronto",
            country: "Canada",
            currentPosition: "AI Research Scientist",
            company: "DeepMind",
            industry: "Artificial Intelligence",
            experienceYears: 7,
            education: [
                Education(institution: "University of Toronto", degree: "PhD", fieldOfStudy: "Machine Learning", startYear: 2015, endYear: 2020)
            ],
            skills: ["PyTorch", "Transformers", "NLP", "Deep Learning"],
            interests: ["AI Ethics", "Open Science", "ML Ops"],
            openTo: [.mentorship, .collaboration],
            connections: []
        ),
        UserProfile(
            fullName: "Michael Brown",
            headline: "Startup Founder | Angel Investor",
            bio: "Founded 2 startups (one exit). Now investing in early-stage SaaS companies.",
            avatarURL: URL(string: "https://i.pravatar.cc/500?img=45"),
            city: "San Francisco",
            country: "USA",
            currentPosition: "Founder & CEO",
            company: "GrowthX",
            industry: "Venture Capital",
            experienceYears: 12,
            education: [
                Education(institution: "Stanford University", degree: "MBA", fieldOfStudy: "Entrepreneurship", startYear: 2008, endYear: 2010)
            ],
            skills: ["Fundraising", "Leadership", "Growth Hacking", "Networking"],
            interests: ["Startups", "SaaS", "Angel Investing"],
            openTo: [.investment, .mentorship, .collaboration],
            connections: []
        ),
        UserProfile(
            fullName: "Chen Wei",
            headline: "Data Engineer @ ByteDance",
            bio: "Loves building scalable data pipelines and optimizing queries. Advocate for women in tech.",
            avatarURL: URL(string: "https://i.pravatar.cc/500?img=51"),
            city: "Beijing",
            country: "China",
            currentPosition: "Data Engineer",
            company: "ByteDance",
            industry: "Social Media",
            experienceYears: 3,
            education: [
                Education(institution: "Tsinghua University", degree: "BSc", fieldOfStudy: "Data Science", startYear: 2014, endYear: 2018)
            ],
            skills: ["Python", "SQL", "Airflow", "BigQuery"],
            interests: ["Analytics", "Visualization", "Cloud"],
            openTo: [.collaboration, .jobSeeking],
            connections: []
        )
    ]

    /// Returns the same users, but each one gets up to `maxPerUser` connections
    /// drawn from the other profiles (name + headline + avatar).
    static func withConnections(maxPerUser: Int = 3) -> [UserProfile] {
        var users = sample
        for i in users.indices {
            let others = users.enumerated()
                .filter { $0.offset != i }
                .map { $0.element }

            users[i].connections = Array(
                others.prefix(maxPerUser).map {
                    Connection(name: $0.fullName, headline: $0.headline, avatarURL: $0.avatarURL)
                }
            )
        }
        return users
    }
}
