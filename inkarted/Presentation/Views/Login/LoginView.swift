import SwiftUI

struct LoginView : View {
    
    
    @EnvironmentObject var navigationStateManager : NavigationStateManager
    
    @State private var isPickerPresented: Bool = false
    @State private var selectedCountry: Country
    @State private var mobileNumber : String = ""
    
    
    @ObservedObject var countryManager: CountryManager;
    
    init() {
        let manager = CountryManager(defaultCountryCode: "+971")
        countryManager = manager
        _selectedCountry = State(initialValue: manager.defaultCountry)
    }
    
    
    let buttonColor = Color(red: 254 / 255, green: 202 / 255, blue: 64 / 255)
    
    var body: some View {
      
        VStack (spacing: 40) {
            
            Text("Ready to buy or sell things?")
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            Text("We're going to send you an OTP to verify you own this number")
                .font(.subheadline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            // Begining of the mobile number
            HStack {
                Button(action: { isPickerPresented = true }) {
                    HStack {
                        Text(selectedCountry.code)
                        Image(systemName: "arrowtriangle.down.fill")
                    }
                    .padding(.leading)
                    .frame(alignment: .leading)
                    .foregroundColor(.black)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedCorners(tl: 20, tr: 0, bl: 20, br: 0))
                }
                
                TextField(selectedCountry.example, text: $mobileNumber)
                    .padding()
                
            }
            .background(Color(.systemGray6))
            .clipShape(RoundedCorners(tl: 20, tr: 20, bl: 20, br: 20))
            .fullScreenCover(isPresented: $isPickerPresented) {
                CountryPicker(selectedCountry: $selectedCountry, isPresented: $isPickerPresented, countries: countryManager.countries)
            }
            

            Spacer()
            
            Button(action: { navigationStateManager.go(to: ScreenType.OTPView)})
            {
                Text("Let's Go")
                    .foregroundColor(.black)
                    .padding()
                    .bold()
                    .frame(width: 350)
                    .background(buttonColor)
                    .cornerRadius(20)
            }
        }
        .padding()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
