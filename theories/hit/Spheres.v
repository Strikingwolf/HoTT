(* -*- mode: coq; mode: visual-line -*- *)

(** * The spheres, in all dimensions. *)

Require Import Overture PathGroupoids Equivalences Paths Bool Suspension Circle.
Local Open Scope path_scope.
Local Open Scope equiv_scope.
Generalizable Variables X A B f g n.

(** ** Definition, by iterated suspension. *)

Fixpoint Sphere (n : trunc_index) : Type 
  := match n with 
       | minus_two => Empty
       | minus_one => Empty
       | trunc_S n' => Susp (Sphere (n'))
     end.

(** ** Explicit equivalences in low dimensions  *)

Definition Sph0_to_Bool : (Sphere 0) -> Bool.
Proof.
  simpl. apply (Susp_rect_nd true false). intros [].
Defined.

Instance isequiv_Sph0_to_Bool : IsEquiv (Sph0_to_Bool).
Proof.
  apply isequiv_adjointify with (fun b : Bool => if b then North else South).
  intros [ | ]; exact 1.
  unfold Sect. apply (Susp_rect _ 1 1). intros [].
Defined.

Definition Sph1_to_S1 : (Sphere (nat_to_trunc_index 1)) -> S1.
Proof.
  apply (Susp_rect_nd base base).
  exact (fun x => if (Sph0_to_Bool x) then loop else 1).
Defined.

Definition S1_to_Sph1 : S1 -> (Sphere (nat_to_trunc_index 1)).
Proof.
  apply (S1_rectnd _ North). exact (merid North @ (merid South)^).
Defined.

Definition isequiv_Sph1_to_S1 : IsEquiv (Sph1_to_S1).
Proof.
  apply isequiv_adjointify with S1_to_Sph1.
    refine (S1_rect _ 1 _).
    refine ((transport_paths_FFlr _ _) @ _).
    unfold S1_to_Sph1; rewrite S1_rectnd_beta_loop.
    rewrite ap_pp, ap_V.
    unfold Sph1_to_S1; rewrite 2 Susp_comp_nd_merid. simpl.
    hott_simpl.
  refine (Susp_rect (fun x => S1_to_Sph1 (Sph1_to_S1 x) = x)
    1 (merid South) _); intros x.
  refine ((transport_paths_FFlr _ _) @ _).
  unfold Sph1_to_S1; rewrite (Susp_comp_nd_merid x).
  revert x. change (Susp Empty) with (Sphere 0). 
  apply (equiv_rect (Sph0_to_Bool ^-1)); intros x.
  case x; simpl. 
    Focus 2. apply concat_1p.
  unfold S1_to_Sph1; rewrite S1_rectnd_beta_loop.
  refine (whiskerR (concat_p1 _) _ @ _).
  apply moveR_Vp. hott_simpl.  
Defined.

