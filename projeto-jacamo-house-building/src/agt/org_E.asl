// Esta empresa licita pisos, paredes e telhados
// Estratégia: um preço fixo mais baixo para realizar todas as 3 tarefas,
// diminui o lance atual em um valor fixo

{ include("common.asl") }

my_price(800).

sum_of_my_offers(S) :-

   .my_name(Me) & .term2string(Me,MeS) &

   .findall( V, currentWinner(MeS)[artifact_id(ArtId)] & currentBid(V)[artifact_id(ArtId)],L) & S = math.sum(L).

/* Planos para fase de leilão */

!discover_art("auction_for_Floors").
!discover_art("auction_for_Walls").
!discover_art("auction_for_Roof").

+currentBid(V)[artifact_id(Art)]

    : not i_am_winning(Art) &

      my_price(P) &

      sum_of_my_offers(Sum) &

      task(S)[artifact_id(Art)] &

      P < Sum + V    

   <- .print("My bid in artifact ", Art, ", at Task ", S,", is ",math.max(V-10,P));

      bid( math.max(V-10,P) )[ artifact_id(Art) ]. 

/* planos para fase de execução */

{ include("org_code.asl") }
{ include("org_goals.asl") }
