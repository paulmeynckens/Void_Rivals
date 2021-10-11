using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;

namespace Core.RuntimeSpawning
{
    [Serializable]
    public struct PrefabAndLocation
    {
        public GameObject prefab;
        public Transform location;
    }

    public struct RuntimeSpawnedPosition
    {
        public uint parentShipNetId;
        public Vector3 localPosition;
        public Quaternion localRotation;
    }

    public interface INeedRuntimeSpawned
    {
        void SetRuntimeSpawned(RuntimeSpawned runtimeSpawned);
    }

}
