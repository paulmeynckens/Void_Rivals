using System.Collections;
using System.Collections.Generic;
using UnityEngine;


namespace FeedbackElements.GunsAnimators
{
    public class MassDriverMagasineAnimator : MagasineAnimator
    {


        Animator animator;

        protected override void Awake()
        {
            base.Awake();
            animator = GetComponent<Animator>();
        }


        protected override void PlayReloadAnimation()
        {
            base.PlayReloadAnimation();

            animator.Play("load");
        }
        protected override void PlayUnloadAnimation()
        {
            base.PlayUnloadAnimation();
            animator.Play("unload");
        }

    }
}

