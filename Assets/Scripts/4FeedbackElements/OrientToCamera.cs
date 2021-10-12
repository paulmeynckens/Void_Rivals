using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using CharacterLogic;
using Core;

namespace FeedbackElements
{
    public class OrientToCamera : MonoBehaviour
    {

        Transform mainCameraTransform;
        private void Awake()
        {
            mainCameraTransform = Camera.main.transform;
        }

        
        private void LateUpdate()
        {
            transform.rotation = mainCameraTransform.rotation;
        }


        
    }


}



