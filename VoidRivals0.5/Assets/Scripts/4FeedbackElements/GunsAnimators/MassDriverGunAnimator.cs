using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace FeedbackElements.GunsAnimators
{
    public class MassDriverGunAnimator : GunAnimator
    {
        Animator animator;
        //RandomSoundPlayer randomSoundPlayer;

        protected override void Awake()
        {
            base.Awake();
            animator = GetComponent<Animator>();
            //randomSoundPlayer = GetComponent<RandomSoundPlayer>();
        }


        protected override void PlayShootAnimation()
        {
            base.PlayShootAnimation();
            //randomSoundPlayer.PlayFeedback();
            animator.Play("shoot");
        }

    }
}

