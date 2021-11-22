using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Core;

namespace PoloGames
{
    public class MagneticBootsTest : MonoBehaviour
    {
        [SerializeField] TwoAxisRotator twoAxis=null;




        [SerializeField] float moveSpeed = 2;

        [SerializeField] float rayHight = 2;

        [SerializeField] Transform[] rayShooters = null;
        

        // Update is called once per frame
        void Update()
        {

            twoAxis.RotateView();

        }

        private void FixedUpdate()
        {
            MoveForward();
            

        }

        void MoveForward()
        {
            if (Input.GetKey(KeyBindings.Pairs[PlayerAction.forward]))
            {
                transform.position += twoAxis.horizontalRotator.forward * Time.fixedDeltaTime * moveSpeed;
                MoveToFoundPosition();
            }
            
        }

        void MoveToFoundPosition()
        {
            


            Vector3 targetPosition =Vector3.zero;
               
            Vector3 targetUpwardDirection = Vector3.zero;

            int foundHitsCount = 0;

            foreach(Transform rayShooter in rayShooters)
            {
                Ray ray = new Ray { origin = rayShooter.position, direction = rayShooter.forward };
                RaycastHit raycastHit;
                if (Physics.Raycast(ray, out raycastHit,rayHight))
                {
                    foundHitsCount++;
                    targetPosition += raycastHit.point;
                    targetUpwardDirection += raycastHit.normal;
                }
            }

            targetPosition = targetPosition / foundHitsCount;
            

            transform.position = targetPosition;
            transform.LookAt(transform.position + transform.forward, targetUpwardDirection);
            
            
            
        }



    }
}
