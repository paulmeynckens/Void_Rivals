using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace ShipsLogic
{
    public class ShipsParking : MonoBehaviour
    {
        public static ShipsParking instance;

        Transform[] parkingLocations;

        private void Awake()
        {
            instance = this;
            parkingLocations = GetComponentsInChildren<Transform>();
            foreach(Transform _transform in parkingLocations)
            {
                if(_transform!=transform)
                _transform.gameObject.SetActive(false);
            }
        }

        public Transform GetAvailableLocation()
        {
            foreach(Transform _transform in parkingLocations)
            {
                if (!_transform.gameObject.activeSelf && _transform!=transform)
                {
                    _transform.gameObject.SetActive(true);
                    return _transform;
                }
            }
            return null;
        }

        public void ReleaseAvalaibleLocation(Transform releasedLocation)
        {
            releasedLocation.gameObject.SetActive(false);
        }
    }
}
