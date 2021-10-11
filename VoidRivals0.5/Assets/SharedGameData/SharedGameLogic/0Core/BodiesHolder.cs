using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Mirror;

namespace Core
{
    public class BodiesHolder : NetworkBehaviour
    {
        public readonly static Dictionary<NetworkIdentity, Transform> interiors = new Dictionary<NetworkIdentity, Transform>();
        public readonly static Dictionary<Transform,NetworkIdentity> interiorsId = new Dictionary<Transform, NetworkIdentity>();

        public readonly static Dictionary<NetworkIdentity, Transform> exteriors = new Dictionary<NetworkIdentity, Transform>();
        public readonly static Dictionary<Transform, NetworkIdentity> exteriorsId = new Dictionary<Transform, NetworkIdentity>();

        public Transform interior = null;
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
            interiors.Add(netIdentity, interior);
            interiorsId.Add(interior, netIdentity);

            exteriors.Add(netIdentity, externalCollider);
            exteriorsId.Add(externalCollider, netIdentity);
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

        private void OnDestroy()
        {
            interiors.Remove(netIdentity);
            interiorsId.Remove(interior);

            exteriors.Remove(netIdentity);
            exteriorsId.Remove(externalCollider);

            Destroy(externalCollider.gameObject);
            Destroy(interior.gameObject);
            
           
        }
    }
}
