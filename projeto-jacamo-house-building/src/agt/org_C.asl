// Esta empresa pode concorrer a todos os tipos de tarefas,
// mas pode comprometer-se com no máximo 2 deles
// Estratégia: preço fixo

{ include("common.asl") }

can_commit :-

   .my_name(Me) & .term2string(Me,MeS) &

   .findall( ArtId, currentWinner(MeS)[artifact_id(ArtId)], L) &

   .length(L,S) & S < 2.

my_price("SitePreparation", 1900).
my_price("Floors",           900).
my_price("Walls",            900).
my_price("Roof",            1100).
my_price("WindowsDoors",    2000).
my_price("Plumbing",         600).
my_price("ElectricalSystem", 300).
my_price("Painting",        1100).

!discover_art("auction_for_SitePreparation").
!discover_art("auction_for_Floors").
!discover_art("auction_for_Walls").
!discover_art("auction_for_Roof").
!discover_art("auction_for_WindowsDoors").
!discover_art("auction_for_Plumbing").
!discover_art("auction_for_ElectricalSystem").
!discover_art("auction_for_Painting").

@[atomic]

+currentBid(V)[artifact_id(Art)]  

    : task(S)[artifact_id(Art)] &

      my_price(S,P) &

      not i_am_winning(Art) & 

      P < V &            

      can_commit                   

   <- .print("My bid in artifact ", Art, ", at Task ", S, ", is ", P);

      bid( P )[ artifact_id(Art) ].

/* planos para fase de execução */

{ include("org_code.asl") }
{ include("org_goals.asl") }
