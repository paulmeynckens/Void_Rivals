using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ShipsLogic;

namespace FeedbackElements
{
    public class DockingPortSoundFeedback : ContinuousSoundFeedbackGenerator
    {
        [SerializeField] DockingPort dockingPort=null;
        ShipDocker shipDocker;
        // Start is called before the first frame update
        private void Awake()
        {
            shipDocker = GetComponentInParent<ShipDocker>();
        }

        // Update is called once per frame
        void Update()
        {
            if(shipDocker.ActiveDockingPort==dockingPort&& shipDocker.IsPulling)
            {
                IncreasePower();
            }
            else
            {
                DecreasePower();
            }
        
        }
    }
}
