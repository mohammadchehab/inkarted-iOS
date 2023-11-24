import SwiftUI
import Combine

struct OTPView: View {
    @FocusState private var focusedField: FocusField?
    enum FocusField: Hashable { case field }

    @State private var otpCode: String = ""
    @State private var otpCodeLength: Int = 4
    var textColor: Color = Color(.black)
    var textSize: CGFloat = 20
    @Binding var mobileNumber: String

    var body: some View {
        VStack(spacing: 40) {
            Text("We've sent you an OTP on \(mobileNumber)")
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)

            Text("We're going to send you an OTP to verify you own this number")
                .font(.subheadline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)

            VStack(alignment: .center) {
                TextField("", text: $otpCode)
                    .frame(width: 0, height: 0, alignment: .center)
                    .font(Font.system(size: 0))
                    .accentColor(.clear)
                    .foregroundColor(.clear)
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
                    .onReceive(Just(otpCode)) { _ in limitText(otpCodeLength) }
                    .focused($focusedField, equals: .field)
                    .task {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.focusedField = .field
                        }
                    }
                    .padding()

                HStack {
                    ForEach(0..<otpCodeLength, id: \.self) { index in
                        ZStack {
                            Text(getPin(at: index))
                                .font(Font.system(size: textSize))
                                .fontWeight(.semibold)
                                .foregroundColor(textColor)
                            Rectangle()
                                .frame(height: 2)
                                .foregroundColor(textColor)
                                .padding(.trailing, 5)
                                .padding(.leading, 5)
                                .opacity(otpCode.count <= index ? 1 : 0)
                        }
                    }
                }
            }

            Spacer()

            Button(action: { }) {
                Text("Confirm")
                    .foregroundColor(.black)
                    .padding()
                    .bold()
                    .frame(width: 350)
                    .background(Color.blue) // Replace ColorConstants.buttonColor with Color.blue for example
                    .cornerRadius(20)
            }
        }
        .padding()
        .navigationBarBackButtonHidden()
    }

    private func getPin(at index: Int) -> String {
        guard otpCode.count > index else {
            return ""
        }
        return String(otpCode[otpCode.index(otpCode.startIndex, offsetBy: index)])
    }

    private func limitText(_ upper: Int) {
        if otpCode.count > upper {
            otpCode = String(otpCode.prefix(upper))
        }
    }
}

#if DEBUG
struct OTPView_Previews: PreviewProvider {
    static var previews: some View {
        OTPView(mobileNumber: .constant("1234567890"))
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
#endif
