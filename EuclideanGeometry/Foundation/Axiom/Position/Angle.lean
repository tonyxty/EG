import EuclideanGeometry.Foundation.Axiom.Linear.Parallel

noncomputable section
namespace EuclidGeom
/- Define values of oriented angles, in (-π, π], modulo 2 π. -/
/- Define oriented angles, ONLY taking in two rays starting at one point!  And define ways to construct oriented angles, by given three points on the plane, and etc.  -/
@[ext]
class Angle (P : Type _) [EuclideanPlane P] where
  start_ray : Ray P
  end_ray : Ray P
  source_eq_source : start_ray.source = end_ray.source

variable {P : Type _} [EuclideanPlane P]

namespace Angle

def mk_pt_pt_pt (A O B : P) (h₁ : A ≠ O) (h₂ : B ≠ O): Angle P where
  start_ray := Ray.mk_pt_pt O A h₁
  end_ray := Ray.mk_pt_pt O B h₂
  source_eq_source := rfl

def mk_ray_pt (ray : Ray P) (A : P) (h : A ≠ ray.source ) : Angle P where
  start_ray := ray
  end_ray := Ray.mk_pt_pt ray.source A h
  source_eq_source := rfl

def mk_dirline_dirline (l₁ l₂ : DirLine P) (h : ¬ l₁ ∥ l₂) : Angle P where
  start_ray := Ray.mk_pt_dirline (Line.inx l₁.toLine l₂.toLine (DirLine.not_para_toline_of_not_para _ _ h) ) l₁ (Line.inx_lies_on_fst (DirLine.not_para_toline_of_not_para _ _ h))
  end_ray := Ray.mk_pt_dirline (Line.inx l₁.toLine l₂.toLine (DirLine.not_para_toline_of_not_para _ _ h) ) l₂ (Line.inx_lies_on_snd (DirLine.not_para_toline_of_not_para _ _ h))
  source_eq_source := rfl

def value (A : Angle P): ℝ := Dir.angle (A.start_ray.toDir) (A.end_ray.toDir)

def is_nd (ang : Angle P) : Prop := ang.value ≠ 0 ∧ ang.value ≠ π

protected def source (ang : Angle P) : P := ang.start_ray.source

end Angle

theorem angle_value_eq_dir_angle (r r' : Ray P) (h : r.source = r'.source) : (Angle.mk r r' h).value = Dir.angle r.toDir r'.toDir := rfl

def value_of_angle_of_three_point_nd (A O B : P) (h₁ : A ≠ O) (h₂ : B ≠ O): ℝ :=
(Angle.mk_pt_pt_pt _ _ _ h₁ h₂).value

def value_of_angle_of_two_ray_of_eq_source (start_ray end_ray : Ray P) (h : start_ray.source = end_ray.source) : ℝ := (Angle.mk start_ray end_ray h).value

scoped notation "ANG" => Angle.mk_pt_pt_pt

scoped notation "∠" => value_of_angle_of_three_point_nd

namespace Angle

-- `should discuss this later, is there a better definition?` ite, dite is bitter to deal with
/- `What does it mean to be LiesIn a angle? when the angle < 0`, for now it is defined as the smaller side. and when angle = π, it is defined as the left side -/

protected def IsInt (p : P) (ang : Angle P) : Prop := by
  by_cases p = ang.source
  · exact False
  · let ray := Ray.mk_pt_pt ang.source p h
    let o₁ := Angle.mk ang.start_ray ray rfl
    let o₂ := Angle.mk ray ang.end_ray (ang.3)
    exact if ang.value > 0 then (o₁.value > 0 ∧ o₂.value > 0) else (o₁.value < 0 ∧ o₂.value < 0)

protected def interior (ang : Angle P) : Set P := { p : P | Angle.IsInt p ang }

instance : Interior P (Angle P) where
  interior := fun o => o.interior

end Angle

theorem eq_end_ray_of_eq_value_eq_start_ray {ang₁ ang₂ : Angle P} (h : ang₁.start_ray = ang₂.start_ray) (v : ang₁.value = ang₂.value) : ang₁.end_ray = ang₂.end_ray := sorry

theorem eq_of_eq_value_eq_start_ray {ang₁ ang₂ : Angle P} (h : ang₁.start_ray = ang₂.start_ray) (v : ang₁.value = ang₂.value) : ang₁ = ang₂ := Angle.ext ang₁ ang₂ h (eq_end_ray_of_eq_value_eq_start_ray h v)

/- theorem - π < angle.value, angle.value ≤ π,  -/

/- theorem when angle > 0, IsInt means lies left of start ray + right of end ray; when angle < 0, ...  -/

/- Operations on oriented angles, such a additivity of the evaluation of oriented angles.  -/
/- theorem l1 l2 l3 add angle; sub angle -/
/- theorem O A B C add angle; sub angle-/

/- 90 degree -/

end EuclidGeom
