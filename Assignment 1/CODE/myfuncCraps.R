myfunc <- function(){
  bal = 1000
  bet = 100
  games = 1
  
  cat('games_no')
  cat(' ')
  cat('result')
  cat(' ')
  cat('bet_amount')
  cat(' ')
  cat('net_bal\n')
  while(bal>0 && games < 11)
  {
    
    x <- craps()
    
    if(x==0) {
      cat(games)
      cat('         ')
      cat('loose')
      cat('    ')
      cat(bet)
      cat('      ')
      bet = bet*2
      bal = bal - bet
      cat(bal)
      cat('\n')
    }
    else{
      
      cat(games)
      cat('         ')
      cat('win')
      cat('     ')
      cat(bet)
      cat('      ')
      bet = 100
      bal = bal + bet
      cat(bal)
      cat('\n')
      
    }
    games = games+1
  }
}