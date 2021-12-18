using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Core.Interractables;

namespace FeedbackElements
{
    public class SwitchableDoorFeedback : DoorFeedback
    {
        [SerializeField] DoorSwitch doorSwitch = null;

        private void Awake()
        {
            doorSwitch.OnDoorChangeState += PlayDockingFeedback;
        }
        

    }
}
