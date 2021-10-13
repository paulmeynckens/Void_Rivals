using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ShipsLogic;

namespace FeedbackElements
{
    public class DockingPortDoorFeedback : DoorFeedback
    {
        [SerializeField] DockingPort dockingPort = null;

        // Start is called before the first frame update
        private void Awake()
        {
            dockingPort.OnDocked += DockingFeedback;

        }


        
    }
}
