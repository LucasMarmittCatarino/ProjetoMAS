// Empresa de preparação de site

{ include("common.asl") }

my_price("SitePreparation", 1000).

!discover_art("auction_for_SitePreparation").

+currentBid(V)[artifact_id(Art)]  
    : task("SitePreparation")[artifact_id(Art)] &
      
      my_price("SitePreparation",P) &

      not i_am_winning(Art) & 

      P < V        
                  
   <- .print("My bid in artifact ", Art, ", at Task SitePreparation, is ", P);
      bid( P )[ artifact_id(Art) ].

+!bid_strategy
   <- ?currentBid(V)[artifact_id(Art)] &
      my_price("SitePreparation",P) &
      NewBid = P - (P * 0.1) &
      bid( NewBid )[ artifact_id(Art) ].

/* planos para fase de execução */

{ include("org_code.asl") }
{ include("org_goals.asl") }