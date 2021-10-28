using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Unity.Audio;
using Mirror;

namespace Core.Interractables
{
    public class DoorSwitch : Interractable
    {
        [SerializeField] Animator doorAnimator = null;


        protected override void ServerUseObjectE(NetworkIdentity requestingPlayer)
        {
            doorAnimator.SetBool("Open", !doorAnimator.GetBool("Open"));

        }




    }
}

