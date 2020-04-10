# distutils: language = c++

from cython cimport view
import numpy as np
cimport numpy as np
from libcpp cimport bool
from libc.stdlib cimport malloc, free
import math
import time

from BTrack cimport BTrack

cdef class BeatTracker(object):
    cdef BTrack* btrack  # hold a pointer to the C++ instance which we're wrapping
    cdef int frame_size

    def __cinit__(self, int hop_size=512, int frame_size=1024):
        self.btrack = new BTrack(hop_size, frame_size);
        self.frame_size = frame_size
        print("Have Fune")
    
    def update_hop_and_frame_size (self, int hop_size, int frame_size) -> void:
        """Updates the hop and frame size used by the beat tracker"""
        self.btrack.updateHopAndFrameSize(hop_size, frame_size)
        self.frame_size = frame_size
    
    def get_hop_size(self) -> int:
        """Returns the current hop size being used by the beat tracker"""
        return self.btrack.getHopSize()
    
    def process_audio(self, np.ndarray audio) -> void:
        """
        Process a single audio frame 

        @param frame a pointer to an array containing an audio frame. The number of samples should 
        match the frame size that the algorithm was initialised with.
        """
        if audio.ndim > 1:
            raise ValueError("audio should have 1 dimension")
        if audio.shape[0] != self.frame_size:
            raise ValueError(f"audio should have {self.frame_size} samples")

        if not audio.flags["C_CONTIGUOUS"] or audio.dtype != np.double:
            audio = np.ascontiguousarray(audio, dtype=np.double)
        
        cdef double [::1] audio_memview = audio

        self.btrack.processAudioFrame(&audio_memview[0])
    
    def process_onset_detection_function_sample(self, double sample):
        """Add new onset detection function sample to buffer and apply beat tracking"""
        self.btrack.processOnsetDetectionFunctionSample(sample)
    
    def beat_due_in_current_frame(self) -> bool:
        """Returns true if a beat should occur in the current audio frame"""
        return self.btrack.beatDueInCurrentFrame()

    def get_current_tempo_estimate(self) -> double:
        """Rturns the current tempo estimate being used by the beat tracker"""
        return self.btrack.getCurrentTempoEstimate()
    
    def get_latest_cumulative_score_value(self) -> double:
        """Returns the most recent value of the cumulative score function"""
        return self.btrack.getLatestCumulativeScoreValue()
    
    def set_tempo(self, double tempo) -> void:
        """Set the tempo of the beat tracker"""
        self.btrack.setTempo(tempo)
    
    def fix_tempo(self, double tempo) -> void:
        """
        Fix tempo to roughly around some value, so that the algorithm will only try to track
        tempi around the given tempo
        """
        self.btrack.fixTempo(tempo)
    
    def do_not_fix_tempo(self) -> void:
        """Tell the algorithm to not fix the tempo anymore"""
        self.btrack.doNotFixTempo()
