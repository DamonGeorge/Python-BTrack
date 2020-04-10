from libcpp cimport bool

cdef extern from "BTrack.cpp":
    pass

cdef extern from "OnsetDetectionFunction.cpp":
    pass


cdef extern from "BTrack.h":
    cdef cppclass BTrack:
        # Constructor assuming hop size of 512 and frame size of 1024 # 
        BTrack();
        
        # Constructor assuming frame size will be double the hopSize
        # @param hopSize the hop size in audio samples
        BTrack (int hopSize_);
        
        # Constructor taking both hopSize and frameSize
        # @param hopSize the hop size in audio samples
        # @param frameSize the frame size in audio samples
        BTrack (int hopSize_, int frameSize_);
        
        # Updates the hop and frame size used by the beat tracker 
        # @param hopSize the hop size in audio samples
        # @param frameSize the frame size in audio samples
        void updateHopAndFrameSize (int hopSize_, int frameSize_);

        # @returns the current hop size being used by the beat tracker # 
        int getHopSize();

        
        # Process a single audio frame 
        # @param frame a pointer to an array containing an audio frame. The number of samples should 
        # match the frame size that the algorithm was initialised with.
        void processAudioFrame (double* frame);
        
        # Add new onset detection function sample to buffer and apply beat tracking 
        # @param sample an onset detection function sample
        void processOnsetDetectionFunctionSample (double sample);
    
        
        
        # @returns true if a beat should occur in the current audio frame # 
        bool beatDueInCurrentFrame();

        # @returns the current tempo estimate being used by the beat tracker # 
        double getCurrentTempoEstimate();
        
        # @returns the most recent value of the cumulative score function # 
        double getLatestCumulativeScoreValue();
        
        # Set the tempo of the beat tracker 
        # @param tempo the tempo in beats per minute (bpm)
        void setTempo (double tempo);
        
        # Fix tempo to roughly around some value, so that the algorithm will only try to track
        # tempi around the given tempo
        # @param tempo the tempo in beats per minute (bpm)
        void fixTempo (double tempo);
        
        # Tell the algorithm to not fix the tempo anymore # 
        void doNotFixTempo();
        
        # Calculates a beat time in seconds, given the frame number, hop size and sampling frequency.
        # This version uses a long to represent the frame number
        # @param frameNumber the index of the current frame 
        # @param hopSize the hop size in audio samples
        # @param fs the sampling frequency in Hz
        # @returns a beat time in seconds
        #static double getBeatTimeInSeconds (long frameNumber, int hopSize, int fs);
        
        # Calculates a beat time in seconds, given the frame number, hop size and sampling frequency.
        # This version uses an int to represent the frame number
        # @param frameNumber the index of the current frame
        # @param hopSize the hop size in audio samples
        # @param fs the sampling frequency in Hz
        # @returns a beat time in seconds
        #static double getBeatTimeInSeconds (int frameNumber, int hopSize, int fs);
        
