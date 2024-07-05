// Esta empresa licita apenas para encanamento
// Estratégia: preço fixo

{ include("common.asl") }

my_price(300).

!discover_art("auction_for_Plumbing").

+currentBid(V)[artifact_id(Art)]

    : not i_am_winning(Art)  & 
      
      my_price(P) & P < V 

   <- .print("My bid in artifact ", Art, " is ",P);

      bid( P ).

/* planos para fase de execução */

{ include("org_code.asl") }

+!plumbing_installed   
   <- installPlumbing. 

