using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace CharacterRenderer
{
    public class CameraManager : MonoBehaviour
    {
        Vector3 initialPosition;
        Quaternion initialRotation;
        Transform localPlayerEyes=null;



        public static CameraManager instance;
        private void Awake()
        {
            instance = this;
            initialPosition = transform.position;
            initialRotation = transform.rotation;
        }

        public void SetEyes(Transform p_eyes)
        {
            localPlayerEyes = p_eyes;
        }

        


        // Update is called once per frame
        void LateUpdate()
        {
            if(localPlayerEyes != null)
            {
                transform.position = localPlayerEyes.position;
                transform.rotation = localPlayerEyes.rotation;
            }
            else
            {
                transform.position = initialPosition;
                transform.rotation = initialRotation;
            }
        
        }
    }
}
