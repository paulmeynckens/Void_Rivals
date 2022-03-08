using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using Core.Interractables;
using System;
using GeneralRendering;
using Mirror;

namespace CharacterRenderer
{
    [Serializable]
    public struct SeatPostureData
    {
        public IKData iKData;
        public Transform viewDirection;
        public bool needsSitting;
    }
    public class SeatPostureDataHolder : MonoBehaviour
    {
        [SerializeField] Seat seat;
        [SerializeField] SeatPostureData seatData;

        public static readonly Dictionary<Seat, SeatPostureData> seatIKs = new Dictionary<Seat, SeatPostureData>();

        private void Awake()
        {
            seatIKs.Add(seat, seatData);
            LinkToRenderer.linkedRenderer.Add(seat.GetComponent<NetworkIdentity>(), transform); ;
        }


    }
}