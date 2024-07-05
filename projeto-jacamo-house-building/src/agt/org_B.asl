// Esta empresa licita para preparação do local
// Estratégia: diminuir seu preço em 150 até seu valor mínimo

{ include("common.asl") }

my_price(1500).

!discover_art("auction_for_SitePreparation").

+currentBid(V)[artifact_id(Art)]
    : not i_am_winning(Art) & 

      my_price(P) & P < V       

   <- .print("My bid in artifact ", Art, " is ",math.max(V-150,P));
      
      bid( math.max(V-150,P) ). 

/* planos para fase de execução */

{ include("org_code.asl") }

+!site_prepared
   <- prepareSite.

