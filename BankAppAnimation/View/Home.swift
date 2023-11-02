import SwiftUI

struct Home: View {
    
    var proxy : ScrollViewProxy
    var size : CGSize
    var safeArea : EdgeInsets
    
    //View Properties
    @State private var activePage: Int = 1
    @State private var myCards: [Card] = sampleCards
    //Page Offset
    @State private var offset: CGFloat = 0
    @State private var isManualAnimating: Bool = false
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing:10){
                ProfileCard()
                
                //Indicator
                
                Capsule()
                    .fill(.gray.opacity(0.2))
                    .frame(width: 50, height: 5)
                    .padding(.vertical, 5)
                
                //Page Tab View Heigh Based on Screen Heigh
                let pageHeight = size.height * 0.65
                
                //Page Tab View - To keep track of MinY
                GeometryReader{
                    let proxy = $0.frame(in: .global)
                    
                    TabView(selection: $activePage){
                        ForEach(myCards) { card in
                            ZStack {
                                if card.isFirtsBlankCard{
                                    Rectangle()
                                        .fill(.clear)
                                } else {
                                    //Card View
                                    CardView(card: card)
                                }
                            }
                            .frame(width: proxy.width - 60)
                            //Page Tag (Index)
                            .tag(index(card))
                            .offsetX(activePage == index(card)) { rect in
                                if !isManualAnimating {
                                //Calculating Entire Page Offset
                                let minX = rect.minX
                                let pageOffset = minX - (size.width * CGFloat(index(card)))
                                offset = pageOffset
                                }
                            }
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .background(){
                        RoundedRectangle(cornerRadius: 40 * reverseProgress(_size: size), style: .continuous)
                            .fill(Color("ExpandBG").gradient)
                            .frame(height: pageHeight + fullScreenHeight(size, pageHeight, safeArea))
                        
                        //Expdanding to Full screen, based on the progress
                            .frame(width: proxy.width - (60 * reverseProgress(_size: CGSizeZero)), height: pageHeight, alignment: .top)
                        
                        //making it little visible at idle
                            .offset(x: -15 * reverseProgress(_size: CGSizeZero))
                            .scaleEffect(0.95 + (0.05 * progress(_size: CGSizeZero)), anchor: .leading)
                        
                        //Moving Along Side with the second card
                            .offset(x: (offset + size.width) < 0 ? (offset + size.width) : 0)
                            .offset(y: (offset + size.width) > 0 ? (-proxy.minY * progress(_size: size)): 0 )
                    }
                }
                .frame(height: pageHeight)
                
                //Making it Above all the views
                .zIndex(1000)
                
                //Displaying Expenses
                ExpensesView(expenses: myCards[activePage == 0 ? 1 : activePage].expenses)
                    .padding(.horizontal, 30)
                    .padding(.top, 10)
            }
            .padding(.top, safeArea.top + 15)
            .padding(.bottom, safeArea.bottom + 15)
            .id("CONTENT")
        }
        .scrollDisabled(activePage == 0)
        .overlay(content: {
            //Displaying under certain condition
            if reverseProgress(_size: size) < 0.15 && activePage == 0{
                ExpandedView()
                
                //Adding Animation
                    .scaleEffect(1 - reverseProgress(_size: size))
                    .opacity(1.0 - (reverseProgress(_size: size) / 0.15))
                    .transition(/*@START_MENU_TOKEN@*/.identity/*@END_MENU_TOKEN@*/)
            }
        })
        
        .onChange(of: offset){ newValue in
            if newValue == 0 && activePage == 0 {
                
                //Scrolling to the top
                proxy.scrollTo("CONTENT", anchor: .topLeading)
            }
        }
    }
    
    // Profile Card View
    @ViewBuilder
    
    func ProfileCard() -> some View{
        HStack(spacing:4){
            Text("Hello")
                .font(.title)
            
            Text("Justine")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            
            Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
            
            Image("Pic")
                .resizable()
                .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                .frame(width: 55, height: 55)
                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
        }
        .padding(.horizontal,30)
        .padding(.vertical, 35)
        .background{
            RoundedRectangle(cornerRadius: 35, style: .continuous)
                .fill(Color("Profile"))
        }
        .padding(.horizontal, 30)
    }
    
    //Expanded View
    @ViewBuilder
    func ExpandedView() -> some View{
        VStack{
            VStack(spacing: 30){
                HStack(spacing:12){
                    Image(systemName: "creditcard.fill")
                        .font(.title2)
                    Text("Credit Card")
                        .font(.title3.bold())
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                .overlay(alignment: .trailing){
                    Button{
                        isManualAnimating = true
                        //Manual closing
                        withAnimation(.easeInOut(duration: 0.25)){
                            activePage = 1
                            offset = -size.width
                        }
                        //Resetting it after the animation has been finished
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.22){
                            isManualAnimating = false
                        }
                    } label: {
                        Image(systemName: "xmark.cirle.fill")
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            .foregroundColor(.white.opacity(0.5))
                    }
                }
                
                HStack(spacing:12){
                    Image(systemName: "building.columns.fill")
                        .font(.title2)
                    Text("Open an account")
                        .font(.title3.bold())
                    
                    Image(systemName: "dollarsign.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.white)
                        .padding(.leading, 5)
                    
                    Image(systemName: "eurosign.circle.fill")
                        .font(.largeTitle)
                        .foregroundColor(.blue)
                        .padding(.leading, -25)
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
            }
            .foregroundColor(.white)
            .padding(25)
            .background{
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(Color("ExpandButton"))
            }
            
            Text("Your Card Number")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.white.opacity(0.35))
                .padding(.top, 10)
            
            //Custom Number Pad
            let values: [String] = [
                "1", "2", "3", "4", "5", "6", "7", "8", "9", "Scan", "0", "back"
            ]
            
            GeometryReader{
                let size = $0.size
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0),count: 3),spacing: 0){
                    ForEach(values, id: \.self) { item in
                        Button{
                            
                        } label: {
                            ZStack{
                                if item == "scan" {
                                    Image(systemName: "barcode.viewfinder")
                                        .font(.title.bold())
                                }else if item == "back"{
                                    Image(systemName: "delete.backward")
                                        .font(.title.bold())
                                }else {
                                    Text(item)
                                        .font(.title.bold())
                                }
                            }
                            .foregroundColor(.white)
                            //Since the are 3 rows and 4 columns
                            .frame(width: size.width / 3, height: size.height / 4)
                            .contentShape(Rectangle())
                        }
                    }
                }
                .padding(.horizontal, -15)
            }
            
            Button {
                
            } label: {
                Text("Add Card")
                    .font(.title2.bold())
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background {
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .fill(Color("ExpandButton"))
                    }
            }
        }
        .padding(.horizontal,15)
        .padding(.top, 15 + safeArea.top)
        .padding(.bottom, 15 + safeArea.bottom)
        .environment(\.colorScheme, .dark)
    }
    
    // Returns Index for Given Card
    
    func index(_ of: Card) -> Int {
        return myCards.firstIndex(of: of) ?? 0
    }
    
    //Full screen height
    func fullScreenHeight(_ size: CGSize, _ pageHeight: CGFloat, _ safeArea: EdgeInsets) -> CGFloat{
        let progress = progress(_size: size)
        let remainingScreenHeight = progress * (size.height - (pageHeight - safeArea.top - safeArea.bottom))
        
        return remainingScreenHeight
        
    }
    
    // Converts Offset Into Progress
    //(0-1)
    func progress(_size: CGSize) -> CGFloat {
        let pageOffset = offset + size.width
        let progress = pageOffset / size.width
        
        return min(progress, 1)
    }
    
    //Reverse Progress (1-0)
    func reverseProgress(_size: CGSize) -> CGFloat {
        let progress = 1 - progress(_size: size)
        return max(progress, 0)
        
    }
}

struct Home_Previews: PreviewProvider{
    static var previews: some View{
        ContentView()
    }
}

// Card View

struct CardView : View {
    
    var card: Card
    
    var body: some View {
        GeometryReader{
            let size = $0.size
            
            VStack(spacing: 0){
                Rectangle()
                    .fill(card.cardColor.gradient)
                
                //Card Details
                
                    .overlay(alignment: .top){
                        VStack{
                            HStack{
                                Image("Sim")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 65, height: 65)
                                
                                Spacer(minLength: 0)
                                
                                Image(systemName: "wave.3.right")
                                    .font(.largeTitle.bold())
                            }
                            
                            Spacer(minLength: 0)
                            
                            Text(card.cardBalance)
                                .font(.largeTitle.bold())
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                        }
                        .padding(30)
                    }
                
                Rectangle()
                    .fill(.black)
                    .frame(height: size.height / 3)
                
                //Card Details
                    .overlay{
                        VStack{
                            Text(card.cardName)
                                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                            
                            Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
                            
                            HStack{
                                Text("Debit Card")
                                    .font(.callout)
                                
                                Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
                                
                                Image("Visa")
                                    .resizable()
                                    .renderingMode(/*@START_MENU_TOKEN@*/.template/*@END_MENU_TOKEN@*/)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 60)
                            }
                        }
                        .foregroundColor(.white)
                        .padding(25)
                    }
            }
            .clipShape(RoundedRectangle(cornerRadius:40, style: .continuous))
        }
    }
}

struct ExpensesView : View {
    
    var expenses : [Expense]
    
    //View Properties
    @State private var animateChange: Bool = true
    
    var body: some View {
        VStack(spacing:18) {
            ForEach(expenses) { expenses in
                HStack(spacing:12){
                    Image(expenses.productIcon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 55,height: 55)
                    
                    VStack(alignment: .leading, spacing: 8){
                        Text(expenses.product)
                        Text(expenses.spendType)
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    Text(expenses.amountSpent)
                        .font(.title3)
                        .fontWeight(.semibold)
                }
            }
        }
        .opacity(animateChange ? 1 : 0)
        .offset(y: animateChange ? 0 : 50)
        .onChange(of: expenses){ newValue in
            withAnimation(.easeInOut(duration: 0.1)) {
                animateChange = false
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                withAnimation(.easeInOut(duration: 0.25)){
                    animateChange = true
                }
            }
        }
    }
}
