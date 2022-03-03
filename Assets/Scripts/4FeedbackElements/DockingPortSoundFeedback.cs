using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using ShipsLogic;

namespace FeedbackElements
{
    public class DockingPortSoundFeedback : ContinuousSoundFeedbackGenerator
    {
        
        [SerializeField] MaleDockingPort maleDockingPort=null;
        
        

        // Update is called once per frame
        void Update()
        {
            if(maleDockingPort.IsPulling)
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
