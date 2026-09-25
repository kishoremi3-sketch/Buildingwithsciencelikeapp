import SwiftUI

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    var tint: Color = BWSTheme.primary

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundStyle(tint)
                Spacer()
            }
            Text(value)
                .font(.title2.bold())
                .lineLimit(1)
                .minimumScaleFactor(0.7)
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(BWSTheme.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
