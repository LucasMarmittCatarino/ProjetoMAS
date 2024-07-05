{ include("common.asl") }

/* Crenças e regras iniciais */

number_of_tasks(NS) :- .findall( S, task(S), L) & .length(L,NS).

/* Initial goals */
!have_a_house.

/* Planos */

+!have_a_house
   <- !contract; 
      !execute; 
   .

-!have_a_house[error(E),error_msg(Msg),code(Cmd),code_src(Src),code_line(Line)]
   <- .print("Falha ao construir uma casa devido a: ",Msg," (",E,"). Commando: ",Cmd, " no ",Src,":", Line).


/* Planos de Contratação */

+!contract
   <- !create_auction_artifacts;
      !wait_for_bids.

+!create_auction_artifacts
   <-  !create_auction_artifact("SitePreparation", 2000);
       !create_auction_artifact("Floors",          1000);
       !create_auction_artifact("Walls",           1000);
       !create_auction_artifact("Roof",            2000);
       !create_auction_artifact("WindowsDoors",    2500);
       !create_auction_artifact("Plumbing",         500);
       !create_auction_artifact("ElectricalSystem", 500);
       !create_auction_artifact("Painting",        1200).

+!create_auction_artifact(Task,MaxPrice)
   <- .concat("auction_for_",Task,ArtName); 
      makeArtifact(ArtName, "tools.AuctionArt", [Task, MaxPrice], ArtId);
      focus(ArtId).

-!create_auction_artifact(Task,MaxPrice)[error_code(Code)]
   <- .print("Error creating artifact ", Code).

+!wait_for_bids
   <- println("Waiting bids for 5 seconds...");
      .wait(5000);
      !show_winners.

+!show_winners
   <- for ( currentWinner(Ag)[artifact_id(ArtId)] ) {
         ?currentBid(Price)[artifact_id(ArtId)];
         ?task(Task)[artifact_id(ArtId)];
         println("Winner of task ", Task," is ", Ag, " for ", Price)
      }.

/* Planos de gestão da execução da construção da casa */

+!execute
   <- println;
      println("*** Execution Phase ***");
      println;

      .my_name(Me);
      createWorkspace("ora4mas");
      joinWorkspace("ora4mas",WOrg);

      makeArtifact(ora4mas, "ora4mas.nopl.OrgBoard", ["src/org/house-os.xml"], OrgArtId)[wid(WOrg)];
      focus(OrgArtId);
      createGroup(hsh_group, house_group, GrArtId);
      debug(inspector_gui(on))[artifact_id(GrArtId)];
      adoptRole(house_owner)[artifact_id(GrArtId)];
      focus(GrArtId);

      !contract_winners("hsh_group");

      makeArtifact("housegui", "simulator.House");

      createScheme(bhsch, build_house_sch, SchArtId);
      debug(inspector_gui(on))[artifact_id(SchArtId)];
      focus(SchArtId);

      ?formationStatus(ok)[artifact_id(GrArtId)];
      addScheme("bhsch")[artifact_id(GrArtId)];
      commitMission("management_of_house_building")[artifact_id(SchArtId)].

+!contract_winners(GroupName)
    : number_of_tasks(NS) &
      .findall( ArtId, currentWinner(A)[artifact_id(ArtId)] & A \== "no_winner", L) &
      .length(L, NS)
   <- for ( currentWinner(Ag)[artifact_id(ArtId)] ) {
            ?task(Task)[artifact_id(ArtId)];
            println("Contracting ",Ag," for ", Task);
            .send(Ag, achieve, contract(Task,GroupName))
      }.

+!contract_winners(_)
   <- println("** I didn't find enough builders!");
      .fail.

+?formationStatus(ok)[artifact_id(G)]
   <- .wait({+formationStatus(ok)[artifact_id(G)]}).

+!house_built 
   <- println("*** Fim ***").
