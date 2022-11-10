//
//  ProspectsView.swift
//  HotProspects
//
//  Created by Pham Anh Tuan on 11/10/22.
//

import SwiftUI
import CodeScanner
import UserNotifications

enum FilterType {
    case none, contacted, uncontacted
}

struct ProspectsView: View {
    @EnvironmentObject var prospects: Prospects
    @EnvironmentObject var fakeContacts: FakeContacts
    
    @State private var isShowingScanner = false
    @State private var isShowingSortDialog = false

    let filter: FilterType
    
    var title: String {
        switch filter {
        case .none:
            return "Everyone"
        case .contacted:
            return "Contacted people"
        case .uncontacted:
            return "Uncontacted people"
        }
    }
    
    var filteredProspects: [Prospect] {
        switch filter {
        case .none:
            return prospects.people
        case .contacted:
            return prospects.people.filter { $0.isContacted }
        case .uncontacted:
            return prospects.people.filter { !$0.isContacted }
        }
    }
    
    func handleScan(result: Result<ScanResult, ScanError>) {
        isShowingScanner = false
        
        switch result {
        case .success(let result):
            let details = result.string.components(separatedBy: "\n")
            guard details.count == 2 else { return }

            let person = Prospect()
            person.name = details[0]
            person.emailAddress = details[1]

            prospects.add(person)
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
    }
    
    func addNotification(for prospect: Prospect) {
        let center = UNUserNotificationCenter.current()

        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.emailAddress
            content.sound = UNNotificationSound.default

//            var dateComponents = DateComponents()
//            dateComponents.hour = 9
//            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }

        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addRequest()
                    } else {
                        print("D'oh")
                    }
                }
            }
        }
    }
    
    func contactIcon(isContacted: Bool) -> some View {
        var systemName = "person.crop.circle.badge.xmark"
        var color = Color.blue
        if isContacted {
            systemName = "person.crop.circle.fill.badge.checkmark"
            color = Color.green
        }
        
        return Image(systemName: systemName).foregroundColor(color)
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredProspects) { prospect in
                    HStack {
                        contactIcon(isContacted: prospect.isContacted)
                            .font(.largeTitle)
                        VStack(alignment: .leading) {
                            Text(prospect.name)
                                .font(.headline)
                            Text(prospect.emailAddress)
                                .foregroundColor(.secondary)
                            Text(prospect.createdDescription)
                                .foregroundColor(Color(UIColor.tertiaryLabel))
                        }
                    }
                    .swipeActions {
                        if prospect.isContacted {
                            Button {
                                prospects.toggle(prospect)
                            } label: {
                                Label("Mark Uncontacted", systemImage: "person.crop.circle.badge.xmark")
                            }
                            .tint(.blue)
                        } else {
                            Button {
                                prospects.toggle(prospect)
                            } label: {
                                Label("Mark Contacted", systemImage: "person.crop.circle.fill.badge.checkmark")
                            }
                            .tint(.green)
                            
                            Button {
                                addNotification(for: prospect)
                            } label: {
                                Label("Remind Me", systemImage: "bell")
                            }
                            .tint(.orange)
                        }
                    }
                    .swipeActions(edge: HorizontalEdge.leading, allowsFullSwipe: true) {
                        Button {
                            prospects.delete(prospect)
                        } label: {
                            Label("Delete", systemImage: "trash.slash")
                        }
                        .tint(.red)
                    }
                }
            }
            .navigationTitle(title)
            .toolbar {
                Button {
                    isShowingSortDialog = true
                } label: {
                    Label("Filter", systemImage: "arrow.up.arrow.down.square")
                }
                
                Button {
                    isShowingScanner = true
                } label: {
                    Label("Scan", systemImage: "qrcode.viewfinder")
                }
            }
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(codeTypes: [.qr], simulatedData: fakeContacts.getRandomFakeContactString(), completion: handleScan)
            }
            .confirmationDialog("Sort Contacts", isPresented: $isShowingSortDialog) {
                
                ForEach(SortType.allCases, id: \.self) { sortType in
                    Button {
                        prospects.sort(sortType)
                    } label: {
                        Text(sortType.rawValue)
                    }
                }
            }
        }
    }
}

struct ProspectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectsView(filter: .none)
    }
}
