using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace FeedbackElements
{
    public class ReplicateRotation : MonoBehaviour
    {
        public Transform toFace=null;

        // Update is called once per frame
        void LateUpdate()
        {
            transform.rotation = toFace.rotation;
        
        }
    }
}
