using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Core;

namespace Sandbox
{
    public class TestSceneMove : MonoBehaviour
    {
        [SerializeField] TwoAxisRotator twoAxis=null;
        [SerializeField] float speed = 5;
        // Start is called before the first frame update
        void Start()
        {
        
        }

        // Update is called once per frame
        void Update()
        {
            twoAxis.RotateView();
            if (Input.GetKey(KeyBindings.Pairs[Actions.forward]))
            {
                transform.position += twoAxis.pointer.forward * speed * Time.deltaTime;
            }
            if (Input.GetKey(KeyBindings.Pairs[Actions.backward]))
            {
                transform.position-= twoAxis.pointer.forward * speed * Time.deltaTime;
            }
            if (Input.GetKey(KeyBindings.Pairs[Actions.right]))
            {
                transform.position+=twoAxis.horizontalRotator.right * speed * Time.deltaTime;
            }
            if (Input.GetKey(KeyBindings.Pairs[Actions.left]))
            {
                transform.position -= twoAxis.horizontalRotator.right * speed * Time.deltaTime;
            }

        }
    }
}
