using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Mirror;

namespace Core
{
    public class BodiesHolder : NetworkBehaviour
    {

        public readonly static Dictionary<Transform, Transform> interiors = new Dictionary<Transform, Transform>();
        public readonly static Dictionary<NetworkIdentity, Transform> exteriors = new Dictionary<NetworkIdentity, Transform>();
        public readonly static Dictionary<Transform, NetworkIdentity> exteriorsId = new Dictionary<Transform, NetworkIdentity>();


        public Transform externalCollider = null;

        Rigidbody _rigidbody;
        public Rigidbody Rigidbody
        {
            get
            {
                if (_rigidbody == null)
                {
                    _rigidbody = externalCollider.GetComponent<Rigidbody>();

                }
                return _rigidbody;
            }

        }

        private void Awake()
        {
            exteriors.Add(netIdentity, externalCollider);
            exteriorsId.Add(externalCollider, netIdentity);
            interiors.Add(externalCollider, transform);
        }

        public void RepopRigidBody()
        {
            if(_rigidbody==null)
            _rigidbody = externalCollider.gameObject.AddComponent<Rigidbody>();
        }
        public void DestroyRigidBody()
        {
            if (_rigidbody != null)
                Destroy(_rigidbody);
        }

        
        

    }
}
