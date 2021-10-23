using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace FeedbackElements.GunsAnimators
{
    public class MachineGunAnimator : GunAnimator
    {
        //RandomSoundPlayer instantFeedBackGenerator;

        [SerializeField] Transform gunsTransform = null;
        [SerializeField] Transform gunTarget = null;
        [SerializeField] float maxGunDegPerSecond = 300f;




        protected override void PlayShootAnimation()
        {
            base.PlayShootAnimation();
            //instantFeedBackGenerator.PlayFeedback();

            gunTarget.Rotate(0, 0, 30);


        }
        private void Update()
        {
            gunsTransform.localRotation = Quaternion.RotateTowards(gunsTransform.localRotation, gunTarget.localRotation, maxGunDegPerSecond * Time.deltaTime); ;
        }



    }
}

