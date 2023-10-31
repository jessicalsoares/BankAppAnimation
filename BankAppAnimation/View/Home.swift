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
                let pageHeigh = size.height * 0.65
                
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
                                //Calculating Entire Page Offset
                                let minX = rect.minX
                                let pageOffset = minX - (size.width * CGFloat(index(card)))
                                offset = pageOffset
                            }
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .background(){
                        RoundedRectangle(cornerRadius: 40, style: .continuous)
                            .fill(Color("ExpandBG").gradient)
                            .frame(width: proxy.width - 60, height: pageHeigh)
                        
                        //making it little visible at idle
                        
                            .offset(x: -15)
                            .scaleEffect(0.95, anchor: .leading)
                            
                        //Moving Along Side with the second card
                        
                            .offset(x: (offset + size.width) < 0 ? (offset + size.width) : 0)
                    }
                }
                .frame(height: pageHeigh)
                
                Text("\(offset)")
            }
            .padding(.top, safeArea.top + 15)
            .padding(.bottom, safeArea.bottom + 15)
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
    
    // Returns Index for Given Card
    
    func index(_ of: Card) -> Int {
        return myCards.firstIndex(of: of) ?? 0
    }
    
    // Converts Offset Into Progress
    func progress(_size: CGSize) -> CGFloat {
        let pageOffset = offset + size.width
        let progress = pageOffset / size.width
        
        return max(progress, 1)
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
