using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace ShipsLogic
{
    [CreateAssetMenu(fileName = "Ship Controller Data", menuName = "MyDatas/Ship Controller Data")]
    public class ShipData : ScriptableObject
    {
        public float rigidbodyMass = 1000;

        public float rigidBodyDrag = 1;

        public float rigidbodyAngularDrag = 5;

        public float yawTorque = 800000;


        public float pitchTorque = 100000;

        
        public float rollTorque = 200000;

        public float engineMaxForwardThrust = 25000;

        public float engineMaxBackwardThrust = 10000;


        public ShipType shipType;

        [Tooltip("For spaceships.")]
        public float stabilisationTorque = 20000;

    }

    public enum ShipType : byte
    {
        space_ship,
        strike_craft
    }
}

